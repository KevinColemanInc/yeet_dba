namespace :yeet_dba do
  desc 'Add foreign keys in a rake migration'
  task add_foreign_keys: :environment do
    foreign_keys = YeetDba::MissingForeignKeys.foreign_keys

    puts "Trying to add #{foreign_keys.length}"
    puts
    foreign_keys.each do |foreign_key|
      
      begin
        ActiveRecord::Migration.add_foreign_key(foreign_key.table_a,
                                                foreign_key.table_b,
                                                column: foreign_key.column)

      rescue ActiveRecord::InvalidForeignKey
        puts "ERROR - #{foreign_key.table_a} . #{foreign_key.column} failed to add key"
      end
    end
  end
end
