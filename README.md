
![Foreign Key by Ary Prasetyo from the Noun Project](./yeet_dba.png)

# yeet_dba - find missing foreign key constraints
[![Gem Version](https://badge.fury.io/rb/yeet_dba.svg)](https://badge.fury.io/rb/yeet_dba) <a href="https://codeclimate.com/github/KevinColemanInc/yeet_dba/maintainability"><img src="https://api.codeclimate.com/v1/badges/a0baa6373d4be7f0d630/maintainability" /></a>[![Build Status](https://travis-ci.com/KevinColemanInc/yeet_dba.svg?branch=master)](https://travis-ci.com/KevinColemanInc/yeet_dba)

yeet_dba scans your rails tables for missing foreign key constraints. If there are no dangling records, it will create a migration to add the foreign key constraints on all the table it is safe.

If you have dangling migrations, check the generator logs to see where you have invalid orphaned rows. Orphaned row meaning a row with an id that doesn't exist in the associated table.

### But why should I use foreign keys?

You can save yourself an N+1 call by checking if the id has a value instead of loading up the object.

```ruby
user.company.id # bad - N+1
user.company_id # good
```

But this doesn't work if you don't nullify the `company_id` when the company is deleted. Foreign key constraints prevent you from deleting a record without cleaning out the associated tables.

### But what is the difference between yeet_db and [lol_dba](https://github.com/plentz/lol_dba)?

lol_dba will only add indexes for RoR models. yeet_dba looks at every table (including join tables) to add foreign key constraints.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yeet_dba'
```

And then execute:

    $ bundle

## Start here

### 1. Find invalid rows

If a row has an id, but there doesn't exist an id the expected associated table, then the row has bad data and should either be fixed by nulling the orphaned row or assigning it to an existing row.

This rake task will scan every column for orphaned rows.

```
$ RAILS_ENV=production rake yeet_dba:find_invalid_columns
```

Sample output:

```
---RESULTS---

🚨Houston, we have a problem 🚨. We found 1 invalid column.

-> notifications.primary_image_id
Invalid rows:   83
Foreign table:  active_storage_attachments

This query should return no results:
SELECT "notifications".* FROM "notifications" left join active_storage_attachments as association_table on association_table.id = notifications.primary_image_id WHERE "notifications"."primary_image_id" IS NOT NULL AND (association_table.id is null)

```

If you need to ignore certain tables from being checked simply add a `.yeet_dba.yml` in the Rails.root directory.

```
---
  exclude_tables:
    - table_to_be_ignored
```

For a sample configuration file check `.yeet_dba.example.yml`.

### 2. Fix invalid rows

You can either manually repair your data via rails console or direct SQL queries, or you can run a rake task to resolve failures.

If your rails association requires a value (e.g. `belongs_to :user, required: true`), then we try to delete the row.

If your rails association says a value is optional, then we try to nullify the value if the schema alls that column to be null.

If your schema does not allow you to nullify a column, we print a warning.

```
$ RAILS_ENV=production rake yeet_dba:nullify_or_destroy_invalid_rows
```

### 3a. Add foreign keys via migration

Now that the database is in a valid state, we can add the foreign keys in a migration.

```
$ RAILS_ENV=production rails g yeet_dba:foreign_key_migration
```

This will create a new migration with for every foreign_key that can safely be added without running into orphaned data errors. We also warn you if active_record models that are missing association declarations (`has_many`, `belongs_to`, etc.)

`WARNING - cannot find an association for alternative_housings . supplier_id | suppliers`

We also warn if we have tables that don't have existing models attached to them. This can be safe to ignore because join tables on many to many relations don't need models, but ideally, everything should have an AR model backing it.

`WARNING - cannot find a model for alternative_housings . supplier_id | suppliers`

Finally, if there is a table that we think should have a foreign key constraint, but there are dangling values we warn you against that too.

`WARNING - orphaned rows alternative_housings . supplier_id | suppliers`

### 3b. Add missing foreign keys as a rake task

You might want to add foreign keys outside of your regular deployment flow in case there are failures and deployment would be blocked by bad data. This would be especially obnoxious for MySql users since you can't rollback migrations on failure.

```
$ RAILS_ENV=production rake yeet_dba:add_foreign_keys
```

Sample output

```
ERROR - users . profile_id failed to add key
```

This rake task is idempotent (safe to run as many times as you need).

## Compatibility

- Rails 5.2 (but it may work with 5.0+)
- Ruby 2.4+

## Road map to v1

- [x] rspec tests
- [x] add rake task identify all dangling records
- [x] add rake task to automatically nullify or destroy dangling records
- [x] run adding foreign keys as rake task instead of generating a migration
- [x] Use rails associations to find columns that should be "not null" to [improve performance](https://stackoverflow.com/questions/1017239/how-do-null-values-affect-performance-in-a-database-search)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kevincolemaninc/yeet_dba. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YeetDb project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kevincolemaninc/yeet_dba/blob/master/CODE_OF_CONDUCT.md).

## Logo design attribute
Foreign Key by Ary Prasetyo from the Noun Project

## Thanks

[AvoVietnam - Chat with Vietnamese](https://www.avovietnam.com)

## Author

Kevin Coleman, [https://kcoleman.me/](https://kcoleman.me)
