#!/usr/bin/env ruby
require 'fileutils'

def create_file(path, content)
  if File.exist?(path)
    puts "Skipping: #{path} (already exists)"
  else
    File.write(path, content)
    puts "Created: #{path}"
  end
end

puts "--- Ruby Database Infrastructure Scaffolder ---"

# 1. Create Directories
['db/migrations', 'db/seeds'].each do |dir|
  unless Dir.exist?(dir)
    FileUtils.mkdir_p(dir)
    puts "Created directory: #{dir}"
  end
end

# 2. Templates
MIGRATE_TEMPLATE = <<~RUBY
  require 'sequel'
  require 'dotenv'
  
  # Load environment variables
  Dotenv.load if defined?(Dotenv)
  
  DATABASE_URL = ENV['DATABASE_URL']
  MIGRATIONS_DIR = File.expand_path('db/migrations', __dir__)
  
  unless DATABASE_URL
    puts "Error: DATABASE_URL environment variable is not set."
    exit 1
  end
  
  begin
    unless Dir.exist?(MIGRATIONS_DIR)
      puts "Error: Migrations directory not found at \#{MIGRATIONS_DIR}"
      exit 1
    end
  
    if Dir.empty?(MIGRATIONS_DIR)
      puts "Warning: Migrations directory is empty. Nothing to do."
      exit 0
    end
  
    puts "Connecting to database..."
    DB = Sequel.connect(DATABASE_URL)
    Sequel.extension :migration
  
    # Check for mixed naming styles (Integer vs Timestamp)
    files = Dir.children(MIGRATIONS_DIR).select { |f| f.end_with?('.rb') }
    has_integers = files.any? { |f| f =~ /^\\d{3}_/ }
    has_timestamps = files.any? { |f| f =~ /^\\d{14}_/ }
  
    if has_integers && has_timestamps
      puts "FATAL ERROR: Mixed naming styles detected in db/migrations!"
      puts "You have both 001_ style and 2026..._ style files."
      puts "Sequel requires you to use only ONE style. Please delete or rename the timestamped files."
      exit 1
    end
  
    # This runs the migrator. IntegerMigrator is used by default for 001_ style files.
    # If a VERSION env var or argument is provided, target that version.
    target = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
    
    if target
      puts "Migrating to version \#{target}..."
      Sequel::Migrator.run(DB, MIGRATIONS_DIR, target: target)
    else
      puts "Migrating to latest version..."
      Sequel::Migrator.run(DB, MIGRATIONS_DIR)
    end
    
    puts "Database is up to date!"
  rescue => e
    puts "Migration failed: \#{e.message}"
    puts e.backtrace.join("\\n")
  end
RUBY

SEED_TEMPLATE = <<~RUBY
  require 'sequel'
  require 'dotenv'
  
  # Load environment variables
  Dotenv.load if defined?(Dotenv)
  
  DATABASE_URL = ENV['DATABASE_URL']
  SEEDS_DIR = File.expand_path('db/seeds', __dir__)
  
  unless DATABASE_URL
    puts "Error: DATABASE_URL environment variable is not set."
    exit 1
  end
  
  # Laravel-style Seeder Runner
  module SeederRunner
    def self.call(db, seeder_class_name)
      # Convert string to class if needed, or handle class directly
      klass = Object.const_get(seeder_class_name)
      instance = klass.new
      instance.run(db)
    rescue NameError
      puts "Error: Seeder class '\#{seeder_class_name}' not found."
    rescue => e
      puts "Error running seeder '\#{seeder_class_name}': \#{e.message}"
      puts e.backtrace.join("\\n")
    end
  end
  
  begin
    unless Dir.exist?(SEEDS_DIR)
      puts "Error: Seeds directory not found at \#{SEEDS_DIR}"
      puts "Creating directory structure..."
      Dir.mkdir(SEEDS_DIR)
    end
  
    puts "Connecting to database..."
    DB = Sequel.connect(DATABASE_URL)
    
    target_argument = ARGV[0] # Optional: ruby seed.rb UserSeeder
  
    DB.transaction do
      if target_argument
        # Run a specific seeder class
        file_path = File.join(SEEDS_DIR, "\#{target_argument}.rb")
        if File.exist?(file_path)
          load file_path
          SeederRunner.call(DB, target_argument)
        else
          puts "Error: Seeder file '\#{target_argument}.rb' not found in \#{SEEDS_DIR}"
          exit 1
        end
      else
        # Default behavior: Run DatabaseSeeder (Laravel style)
        db_seeder_path = File.join(SEEDS_DIR, "DatabaseSeeder.rb")
        if File.exist?(db_seeder_path)
          load db_seeder_path
          SeederRunner.call(DB, "DatabaseSeeder")
        else
          # If no DatabaseSeeder, run all files in the folder (backup behavior)
          puts "No DatabaseSeeder.rb found. Running all seeders in db/seeds/..."
          seed_files = Dir.glob(File.join(SEEDS_DIR, '*.rb')).sort
          seed_files.each do |file|
            class_name = File.basename(file, '.rb')
            next if class_name == 'DatabaseSeeder' # prevent double run if it exists but wasn't found (unlikely)
            load file
            SeederRunner.call(DB, class_name)
          end
        end
      end
    end
    
    puts "\\nSeeding completed successfully!"
    
  rescue => e
    puts "Seeding failed: \#{e.message}"
    puts e.backtrace.join("\\n")
    exit 1
  end
RUBY

MAKE_MIGRATION_TEMPLATE = <<~RUBY
  if ARGV[0].nil?
    puts "Usage: ruby make_migration.rb <name>"
    exit 1
  end
  
  migration_name = ARGV[0].gsub(/[^a-zA-Z0-9_]/, '').downcase
  
  # Find the next available version number
  migrations_dir = 'db/migrations'
  Dir.mkdir(migrations_dir) unless Dir.exist?(migrations_dir)
  
  existing_migrations = Dir.children(migrations_dir).select { |f| f =~ /^\\d{3}_/ }
  max_version = existing_migrations.map { |f| f.split('_').first.to_i }.max || 0
  next_version = format('%03d', max_version + 1)
  
  filename = "\#{migrations_dir}/\#{next_version}_\#{migration_name}.rb"
  
  content = <<~TEMPLATE
    Sequel.migration do
      up do
        # create_table(:table_name) do
        #   primary_key :id
        # end
      end
  
      down do
        # drop_table(:table_name)
      end
    end
  TEMPLATE
  
  File.write(filename, content)
  puts "Successfully created: \#{filename}"
RUBY

MAKE_SEEDER_TEMPLATE = <<~RUBY
  if ARGV[0].nil?
    puts "Usage: ruby make_seeder.rb <NameSeeder>"
    puts "Example: ruby make_seeder.rb InitialRbacSeeder"
    exit 1
  end
  
  # Sanitize the seeder name (remove non-alphanumeric chars, CamelCase it)
  seeder_name = ARGV[0].gsub(/[^a-zA-Z0-9_]/, '').split('_').map(&:capitalize).join
  
  # Ensure it ends with Seeder for consistency
  seeder_name += "Seeder" unless seeder_name.end_with?("Seeder")
  
  # Ensure the seeds directory exists
  seeds_dir = 'db/seeds'
  Dir.mkdir(seeds_dir) unless Dir.exist?(seeds_dir)
  
  filename = "\#{seeds_dir}/\#{seeder_name}.rb"
  
  if File.exist?(filename)
    puts "Error: Seeder \#{seeder_name} already exists!"
    exit 1
  end
  
  content = <<~TEMPLATE
    class \#{seeder_name}
      def run(db)
        puts "Running seeder: \#{seeder_name}..."
        
        # Use the db connection passed to insert data
        # db[:table_name].find_or_create(
        #   column: 'value'
        # )
        
        puts "Finished seeder: \#{seeder_name}"
      end
    end
  TEMPLATE
  
  File.write(filename, content)
  puts "Successfully created: \#{filename}"
RUBY

DATABASE_SEEDER_TEMPLATE = <<~RUBY
  class DatabaseSeeder
    def run(db)
      puts "Starting Database Seeder..."
  
      # Pattern: run_seeder(db, 'YourSeederName')
      # run_seeder(db, 'InitialDataSeeder')
  
      puts "Database seeding completed!"
    end
  
    private
  
    def run_seeder(db, class_name)
      file_path = File.join(__dir__, "\#{class_name}.rb")
      if File.exist?(file_path)
        load file_path
        klass = Object.const_get(class_name)
        klass.new.run(db)
      else
        puts "Warning: Seeder file '\#{class_name}.rb' not found."
      end
    end
  end
RUBY

# 3. Write Files
create_file('migrate.rb', MIGRATE_TEMPLATE)
create_file('seed.rb', SEED_TEMPLATE)
create_file('make_migration.rb', MAKE_MIGRATION_TEMPLATE)
create_file('make_seeder.rb', MAKE_SEEDER_TEMPLATE)
create_file('db/seeds/DatabaseSeeder.rb', DATABASE_SEEDER_TEMPLATE)

puts "\\nSetup complete! You can now use:"
puts " - ruby make_migration.rb create_users"
puts " - ruby make_seeder.rb User"
puts " - ruby migrate.rb"
puts " - ruby seed.rb"
puts "\\nEnsure you have 'sequel' and 'dotenv' gems in your Gemfile."
