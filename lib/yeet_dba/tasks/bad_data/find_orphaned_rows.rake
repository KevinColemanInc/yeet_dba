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
        puts "-> #{invalid_column.table_name}.#{invalid_column.db_column_name}"
        puts "Invalid rows:   #{invalid_column.orphaned_rows_count}"
        puts "Foreign table:  #{invalid_column.association_table_name}"
        puts
        puts 'This query should return no results:'
        puts invalid_column.query
        puts
      end
    end
  end

  desc 'Set all of the rows to null if there is bad data'
  task nullify_or_destroy_invalid_rows: :environment do
    columns = YeetDba::MissingForeignKeys.invalid_columns
    next puts "Your data looks good!" if columns.empty?

    columns.each do |column|
      puts column.to_s
    end
    puts
    puts "WARNING - THIS MAY CAUSE PERM DATA LOSS"
    puts
    puts "I am going to give you 8s to change your mind"
    sleep 8
    puts "ok, here we go..."
    sleep 1

    columns.each do |invalid_column|
      required = invalid_column.column.association.options&.key?(:optional) ? !invalid_column.column.association.options[:optional] : invalid_column.column.model.belongs_to_required_by_default
      nullable = invalid_column.column.db_column.null
      if required
        # delete
        invalid_column.verify_data.orphaned_rows.destroy_all
      elsif nullable
        # null it out
        invalid_column.verify_data.orphaned_rows.update_all(invalid_column.db_column.name => nil)
      else
        puts "WARNING - #{invalid_column.table_name} . #{invalid_column.db_column.name} is not nullable"
      end
    end
  end
end
