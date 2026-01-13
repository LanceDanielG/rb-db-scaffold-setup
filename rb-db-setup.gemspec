require_relative 'lib/rb_db_setup/version'

Gem::Specification.new do |spec|
  spec.name          = "rb-db-setup"
  spec.version       = RbDbSetup::VERSION
  spec.authors        = ["Lance Daniel Gallos"]
  spec.email         = ["lancedanielgallos4@gmail.com"]

  spec.summary       = "A Laravel-style database infrastructure scaffolder for Ruby."
  spec.description   = "Instantly adds hardened Sequel migrations and modular seeders to any Ruby project."
  spec.homepage      = "https://github.com/LanceDanielG/rb-db-scaffold-setup"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/LanceDanielG/rb-db-scaffold-setup"
  spec.metadata["changelog_uri"]   = "https://github.com/LanceDanielG/rb-db-scaffold-setup/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/LanceDanielG/rb-db-scaffold-setup/issues"

  spec.files         = Dir.glob("{bin,lib}/**/*") + ["README.md"]
  spec.bindir        = "bin"
  spec.executables   = ["rb-db-setup"]
  spec.require_paths = ["lib"]

  spec.add_dependency "sequel"
  spec.add_dependency "dotenv"
end
