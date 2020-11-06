module YeetDba
  class Column
    attr_accessor :db_column, :table_name, :tables

    def initialize(db_column:, table_name:, tables:)
      @db_column = db_column
      @table_name = table_name
      @tables = tables
    end

    def is_association?
      db_column.name =~ /_id\z/
    end

    def association_klass
      association&.klass
    end

    def association_table_name
      if association_klass&.ancestors&.include?(ActiveRecord::Base)
        association_klass&.table_name
      else
        tables.detect { |table| table == guessed_table_name }
      end
    end

    def association_name
      db_column.name.gsub(/_id\z/, '')
    end

    def model
      ActiveRecord::Base.descendants.detect { |c| c.table_name == table_name }
    end
    
    def association
      model && model.reflections[association_name]
    end

    def polymorphic_association?
      association && association.options[:polymorphic]
    end

    def foreign_key_exists?
      ActiveRecord::Migration.foreign_key_exists?(table_name, column: db_column.name)
    end

    def guessed_table_name
      @guessed_table_name ||= association_name.pluralize
    end
  end
end
