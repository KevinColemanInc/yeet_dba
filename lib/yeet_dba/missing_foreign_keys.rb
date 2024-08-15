module YeetDba
  class MissingForeignKeys
    def self.foreign_keys
      eager_load!
      tables.map do |table_name|
        Table.new(table_name: table_name,
                  tables: tables).missing_keys(ignored_columns[table_name])
      end.flatten
    end

    def self.invalid_columns
      eager_load!
      tables.map do |table_name|
        Table.new(table_name: table_name,
                  tables: tables).invalid_columns(ignored_columns[table_name])
      end.flatten
    end

    def self.eager_load!
      Rails.application.eager_load! if defined?(Rails) && !Rails.env.test?
    end

    def self.tables
      ActiveRecord::Base.connection.tables - self.ignored_tables
    end

    def self.ignored_tables
      config['exclude_tables'] || []
    end

    def self.ignored_columns
      config['exclude_columns'] || {}
    end

    def self.config
      @config ||= begin
        config_file = Pathname.new(Rails.root).join('.yeet_dba.yml')

        if File.exist?(config_file)
          YAML.load(File.read(config_file))
        else
          {}
        end
      end
    end
  end
end
