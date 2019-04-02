module YeetDba
  class Table
    attr_accessor :table_name, :tables

    def initialize(table_name:, tables:)
      @table_name = table_name
      @tables = tables
    end

    def invalid_columns
      missing_keys_array = []
      columns.each do |column_name|
        column = Column.new(column_name: column_name, table_name: table_name, tables: tables)
        next unless column.is_association?
        next if column.polymorphic_association?
        next if column.foreign_key_exists?
        next if column.association_table_name.blank?
        verify_data = VerifyData.new(column: column)
        next unless verify_data.orphaned_rows?

        invalid_column = InvalidColumn.new(table: table_name,
                                        column: column_name.name,
                                        associated_table: column&.association_table_name,
                                        query: verify_data.query,
                                        orphaned_rows_count: verify_data.orphaned_rows_count)
        missing_keys_array.push(invalid_column)

      end
      missing_keys_array
    end

    def missing_keys
      missing_keys_array = []
      columns.each do |column_name|
        column = Column.new(column_name: column_name, table_name: table_name, tables: tables)
        next unless column.is_association?

        unless column.model
          puts "WARNING - cannot find a model for #{table_name} . #{column_name.name} | #{column&.association_table_name}"
        end

        unless column.association
          puts "WARNING - cannot find an association for #{table_name} . #{column_name.name} | #{column&.association_table_name}"
        end

        next if column.polymorphic_association?
        next if column.foreign_key_exists?
        next if column.association_table_name.blank?

        if VerifyData.new(column: column).orphaned_rows?
          puts "YeetDba - orphaned rows. Skipping #{table_name} . #{column_name.name} | #{column&.association_table_name}"
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