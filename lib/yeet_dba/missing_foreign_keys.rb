module YeetDba
  class MissingForeignKeys
    def self.foreign_keys
      eager_load!
      tables.map do |table_name|
        Table.new(table_name: table_name,
                  tables: tables).missing_keys
      end.flatten
    end

    def self.invalid_columns
      eager_load!
      tables.map do |table_name|
        Table.new(table_name: table_name,
                  tables: tables).invalid_columns
      end.flatten
    end

    def self.eager_load!
      Rails.application.eager_load! if defined?(Rails) && !Rails.env.test?
    end

    def self.tables
      ActiveRecord::Base.connection.tables
    end
  end
end
