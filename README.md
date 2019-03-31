![Foreign Key by Ary Prasetyo from the Noun Project](./yeet_dba.png)

# yeet_dba - find missing foreign key constraints
[![Gem Version](https://badge.fury.io/rb/yeet_dba.svg)](https://badge.fury.io/rb/yeet_dba) <a href="https://codeclimate.com/github/KevinColemanInc/yeet_dba/maintainability"><img src="https://api.codeclimate.com/v1/badges/a0baa6373d4be7f0d630/maintainability" /></a>[![Build Status](https://travis-ci.com/KevinColemanInc/yeet_dba.svg?branch=master)](https://travis-ci.com/KevinColemanInc/yeet_dba)

yeet_dba scans your rails tables for missing foreign key constraints. If there are no dangling records, it will create a migration to add the foreign key constraints on all the table it is safe.

If you have dangling migrations, check the generator logs to see where you have invalid orphaned rows. Orphaned row meaning a row with an id that doesn't exist in the associated table.

but [why should I use foreign keys?](https://softwareengineering.stackexchange.com/a/375708)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yeet_dba'
```

And then execute:

    $ bundle

## Usage

This probably should run against the production database so you can know if there are dangling records. If there are records with a value, but not the corresponding table does not have an id, then the migration will fail.

```
$ RAILS_ENV=production rails g yeet_dba:foreign_key_migration
```

This will create a new migration with for every foreign_key that can safely be added without running into orphaned data errors. We also warn you if active_record models that are missing association declarations (`has_many`, `belongs_to`, etc.)`

`WARNING - cannot find association for alternative_housings . supplier_id | suppliers`

We also warn if we have tables that don't have existing models attached to them. This can be safe to ignore, because join tables on many to many relations don't need models, but ideally everything should have an AR model backing it.

`WARNING - cannot find model for alternative_housings . supplier_id | suppliers`

Finnally, if there is a table that we think should have a foreign key constraint, but there are dangling values we warn you against that too.

`WARNING - orphaned rows alternative_housings . supplier_id | suppliers`

## Compatibility

Rails 5.2 (but it may work with 5.0+)
Ruby 2.4+

## Road map to v1

- [ ] rspec tests
- [ ] add rake task identify all dangling records
- [ ] add rake task to automatically nullify or destroy dangling records
- [ ] run as a rake task
- [ ] support "soft delete" gems


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