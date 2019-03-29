# require 'generators/yeet_dba/generator_helpers'

module YeetDba
  # Custom scaffolding generator
  class ForeignKeyMigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
    desc "Generates migration for adding foreign key constraints."   

    def copy_migration_and_spec_files
      migration_template "add_foreign_keys_yeet_dba.rb",
                         migration_file,
                         migration_version: migration_version
    end

    private

    def migration_file
      File.join("db/migrate", "add_foreign_keys_yeet_dba.rb")
    end

    def migration_version
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
    end

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S%L")
    end
  end
end