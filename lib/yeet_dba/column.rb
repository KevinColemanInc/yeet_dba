module YeetDba
  class Column
    attr_accessor :column_name, :table_name, :tables

    def initialize(column_name:, table_name:, tables:)
      @column_name = column_name
      @table_name = table_name
      @tables = tables
    end

    def is_association?
      column_name.name =~ /_id\z/
    end

    def association_klass
      model && model.reflections[association_name]&.klass
    end

    def association_table_name
      association_klass&.table_name || tables.detect { |table| table == guessed_table_name }
    end

    def association_name
      column_name.name.gsub(/_id\z/, '')
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
      ActiveRecord::Migration.foreign_key_exists?(table_name, column: column_name.name)
    end

    def guessed_table_name
      @guessed_table_name ||= association_name.pluralize
    end
  end
end
