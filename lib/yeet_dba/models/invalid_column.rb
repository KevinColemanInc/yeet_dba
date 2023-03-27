module YeetDba
  class InvalidColumn
    attr_accessor :table_name,
                  :column,
                  :verify_data

    def initialize(table_name:, column:, verify_data:)
      @table_name = table_name
      @column = column
      @verify_data = verify_data
    end

    delegate :association_table_name, :db_column, :association, to: :column
    delegate :orphaned_rows_count, :query, to: :verify_data

    def to_s
      "#{table_name} . #{db_column_name} has #{orphaned_rows_count} invalid rows with foreign table #{association_table_name}"
    end

    def db_column_name
      db_column.name
    end
  end
end
