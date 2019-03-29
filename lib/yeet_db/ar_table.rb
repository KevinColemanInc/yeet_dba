module YeetDb
  class ArTable
    attr_accessor :table_name, :tables

    def initialize(table_name:, tables:)
      @table_name = table_name
      @tables = tables
    end

    def missing_keys
      missing_keys_array = []
      columns.each do |column_name|
        column = ArColumn.new(column_name: column_name, table_name: table_name, tables: tables)
        next unless column.is_association?

        unless column.model
          puts "YeetDb - cannot find model for #{table_name} . #{column_name.name} | #{column&.association_table_name}"
        end

        unless column.association
          puts "YeetDb - cannot find association for #{table_name} . #{column_name.name} | #{column&.association_table_name}"
        end

        next if column.polymorphic_association?
        next if column.foreign_key_exists?
        next if column.association_table_name.blank?

        if VerifyData.new(column: column).orphaned_rows?
          puts "YeetDb - orphaned rows. Skipping #{table_name} . #{column_name.name} | #{column&.association_table_name}"
          next
        end

        foreign_key = ForeignKey.new(table_a: table_name,
                                     table_b: column&.association_table_name,
                                     column: column_name.name)
        missing_keys_array.push(foreign_key)
      end
      missing_keys_array
    end

    private

    def columns
      ActiveRecord::Base.connection.columns(table_name)
    end
  end
end