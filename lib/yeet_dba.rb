require 'yeet_dba/version'
require 'yeet_dba/table'
require 'yeet_dba/foreign_key'
require 'yeet_dba/missing_foreign_keys'
require 'yeet_dba/verify_data'
require 'yeet_dba/railtie' if defined?(Rails)
require 'yeet_dba/column'

module YeetDba
  class Error < StandardError; end
end
