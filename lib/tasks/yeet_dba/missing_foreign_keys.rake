require 'yeet_dba'
require 'rails'

module YeetDba
  class Railtie < Rails::Railtie
    railtie_name :yeet_dba

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end