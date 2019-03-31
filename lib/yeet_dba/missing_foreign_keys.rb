module YeetDba
  class MissingForeignKeys
    def self.foreign_keys
      Rails.application.eager_load! if defined?(Rails) && !Rails.env.test?
      tables = ActiveRecord::Base.connection.tables
      tables.map do |table_name|
        Table.new(table_name: table_name,
                  tables: tables).missing_keys
      end.flatten
    end
  end
end
