module YeetDba
  class VerifyData
    attr_accessor :column

    def initialize(column:)
      @column = column
    end

    def orphaned_rows?
      orphaned_rows.first
    end

  private

    def orphaned_rows
      association = column.association

      column_name = column.column_name.name
      table_name = column.table_name
      association_table = column.association_table_name
      model = column.model

      # Check to see there could be rows with bad data
      bad_ids = model.joins("left join #{association_table} as association_table on association_table.id = #{table_name}.#{column_name}")
                     .where.not(column_name => nil)
                     .where('association_table.id is null')
                     .pluck(:id)

      # select the rows with the invalid ids
      # AR doesn't support joins with update, so the bad_ids are selected in a different query (above ^)
      model.where(id: bad_ids)
    end
  end
end
