require 'bundler/setup'
require 'rails/all'
require 'yeet_dba'

ENV['RAILS_ENV'] ||= 'test'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

module Rails
  def self.root
    Pathname.new('./spec/fixtures/')
  end
end
Dir.glob("#{Rails.root}app/models/*.rb").sort.each { |file| require_dependency file }

ActiveRecord::Schema.verbose = false
load 'fixtures/schema.rb'

root_dir = File.dirname(__FILE__)

# add current dir to the load path
$LOAD_PATH.unshift('.')

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
