module YeetDba
  class InvalidColumn
    attr_accessor :table,
                  :column,
                  :associated_table,
                  :query,
                  :orphaned_rows_count

    def initialize(table:, associated_table:, column:, query:, orphaned_rows_count:)
      @table = table
      @associated_table = associated_table
      @column = column
      @query = query
      @orphaned_rows_count = orphaned_rows_count
    end

    def to_s
      "#{table} . #{column} has #{orphaned_rows_count} invalid rows with foreign table #{associated_table}"
    end
  end
end
