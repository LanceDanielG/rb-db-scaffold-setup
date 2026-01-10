# RbDbSetup 🚀

> [!NOTE]
> This is a **personal scaffolding personal setup** created to automate the database infrastructure for my own Ruby projects. It is tailored for my specific workflow but is open for public use!

## Features

- **Class-Based Seeders**: Organize your seeding logic into clean, reusable classes.
- **Central Orchestration**: Uses a `DatabaseSeeder.rb` entry point, just like Laravel's `DatabaseSeeder`.
- **Hardened Migrations**: Automated migration scripts with fail-safe checks and naming consistency.
- **Convenient Generators**:
  - `rb-db-setup`: Scaffolds the entire infrastructure.
  - `ruby make_migration.rb <name>`: Generates sanitized migration templates.
  - `ruby make_seeder.rb <Name>`: Generates class-based seeder templates.
- **Atomic Seeding**: Seeding runs within database transactions to ensure data integrity.
- **Cross-Platform**: Works perfectly on Linux, macOS, and Windows.

## Installation

### Standard Installation
If you've installed it as a RubyGem:
```bash
gem install rb-db-setup
```

### Alternative: Clone & Run (Local)
If you have cloned the repository, you can run the tool directly from the project root:
```bash
ruby bin/rb-db-setup
```

### Alternative: Manual Setup (Copy & Run)
If you just want the logic without installing a gem or cloning the whole repo, you can simply grab the `setup_db_tools.rb` script:
1. Copy [setup_db_tools.rb](setup_db_tools.rb) to your project.
2. Run it:
```bash
ruby setup_db_tools.rb
```
*Note: You can delete the script after it generates the infrastructure.*

### GitHub One-Liner (Fastest)
Run the latest version directly from GitHub without downloading anything:
```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/LanceDanielG/rb-db-scaffold-setup/main/setup_db_tools.rb)"
```

## Global Local Setup (Command Anywhere)

If you want the `rb-db-setup` command to work in **any folder** on your machine without publishing a gem, use the included installer scripts.

### Linux / macOS
Run the installer to copy the script to `~/.local/bin` and update your PATH:
```bash
bash install.sh && source ~/.bashrc
```

### Windows (PowerShell)
Run the PowerShell installer to set up a permanent command and update your User PATH:
```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

Once installed, you can simply type `rb-db-setup` in any terminal window.

## Usage

In any new Ruby project folder, simply run:
```bash
rb-db-setup
```

This will automatically create the following structure:
```text
.
├── db/
│   ├── migrations/      # Your SQL/Sequel migrations
│   └── seeds/           # Class-based seeder files
│       └── DatabaseSeeder.rb
├── migrate.rb           # Hardened migration runner
├── seed.rb              # Laravel-style seeder runner
├── make_migration.rb    # Migration generator
└── make_seeder.rb       # Seeder generator
```

### Running Migrations
```bash
ruby migrate.rb
```

### Running Seeders
To run all seeders (via `DatabaseSeeder.rb`):
```bash
ruby seed.rb
```

To run a specific seeder class:
```bash
ruby seed.rb AdminSeeder
```

## Configuration

The generated scripts expect a `DATABASE_URL` environment variable. They automatically handle `.env` files if the `dotenv` gem is present in your project's `Gemfile`.

## Dependencies

The generated infrastructure requires:
- `sequel`
- `pg` (or your preferred database driver)
- `dotenv` (optional but recommended)

## Automated Publishing with GitHub Actions 🤖

I've included a GitHub Action to automate the publishing of this gem to RubyGems.org.

### How to set it up:
1. **Get your API Key**: Go to [RubyGems.org Settings](https://rubygems.org/profile/edit) and generate a new API key with "Push rubygem" permissions.
2. **Add to GitHub Secrets**: 
   - Go to your repository on GitHub.
   - Click **Settings** > **Secrets and variables** > **Actions**.
   - Create a **New repository secret** named `RUBYGEMS_API_KEY` and paste your key.
3. **Trigger a Release**:
   - Every time you push a **tag** starting with `v` (e.g., `git tag v0.1.0 && git push origin v0.1.0`), GitHub will automatically build and publish the gem for you!

## License

MIT License. See [LICENSE](LICENSE) for more information.
