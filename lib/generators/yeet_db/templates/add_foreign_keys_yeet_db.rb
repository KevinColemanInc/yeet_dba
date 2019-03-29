# frozen_string_literal: true

class AddForeignKeysYeetDb < ActiveRecord::Migration<%= migration_version %>
  def change
   <% ::YeetDb::MissingForeignKeys.foreign_keys.each do |foreign_key| %>
    add_foreign_key :<%= foreign_key.table_a %>,
                    :<%= foreign_key.table_b %>,
                    column: :<%= foreign_key.column %>
   <% end %>
  end
end
