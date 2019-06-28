module YeetDba
  class VerifyData
    attr_accessor :column

    def initialize(column:)
      @column = column
    end

    def orphaned_rows?
      orphaned_rows.first
    end

    def orphaned_rows_count
      orphaned_rows.count
    end

    def query
      orphaned_rows.to_sql
    end

    def orphaned_rows
      association = column.association

      column_name = column.db_column.name
      table_name = column.table_name
      association_table = column.association_table_name
      model = column.model

      # Check to see there could be rows with bad data
      model.joins("left join #{association_table} as association_table on association_table.id = #{table_name}.#{column_name}")
           .where.not(column_name => nil)
           .where('association_table.id is null')
    end
  end
end
