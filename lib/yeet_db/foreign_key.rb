module YeetDb
  class ForeignKey
    attr_accessor :table_a,
                  :table_b,
                  :column

    def initialize(table_a:, table_b:, column:)
      @table_a = table_a
      @table_b = table_b
      @column = column
    end
  end
end