namespace :yeet_dba do
  desc 'Show all of the tables.columns with bad data'
  task find_invalid_columns: :environment do
    columns = YeetDba::MissingForeignKeys.invalid_columns
    puts
    puts '---RESULTS---'
    puts
    if columns.empty?
      puts 'All good here. 👍'
    else
      puts "🚨Houston, we have a problem 🚨. We found #{columns.length} invalid column#{columns.length == 1 ? '' : 's'}."
      puts
      columns.each do |invalid_column|
        puts "-> #{invalid_column.table}.#{invalid_column.column}"
        puts "Invalid rows:   #{invalid_column.orphaned_rows_count}"
        puts "Foreign table:  #{invalid_column.associated_table}"
        puts
        puts 'This query should return no results:'
        puts invalid_column.query
        puts
      end
    end
  end
end
