require "yeet_db/version"
require "yeet_db/ar_column"
require "yeet_db/ar_table"
require "yeet_db/foreign_key"
require "yeet_db/missing_foreign_keys"
require "yeet_db/verify_data"

module YeetDb
  class Error < StandardError; end
end
