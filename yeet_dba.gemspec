lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yeet_dba/version'

Gem::Specification.new do |spec|
  spec.name          = 'yeet_dba'
  spec.version       = YeetDba::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Kevin Coleman']
  spec.email         = ['kevin.coleman@sparkstart.io']

  spec.summary       = 'Generates foreign key constraint migrations for rails databases'
  spec.description   = "This scan every ActiveRecord model looking for relationships ('has_many', 'belongs_to', etc.) and adds foreign key constraints."
  spec.homepage      = 'http://rubygems.org/gems/yeet_dba'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/kevincolemaninc/yeet_dba'
    spec.metadata['changelog_uri'] = 'https://github.com/kevincolemaninc/yeet_dba/master/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.required_ruby_version = '>= 2.4.0'
  spec.add_dependency 'actionpack', '>= 3.0', '< 8.0'
  spec.add_dependency 'activerecord', '>= 3.0', '< 8.0'
  spec.add_dependency 'railties', '>= 3.0', '< 8.0'
end
