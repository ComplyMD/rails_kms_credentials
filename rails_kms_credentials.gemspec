# frozen_string_literal: true

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'rails_kms_credentials/version'

Gem::Specification.new do |s|
  s.name        = 'rails_kms_credentials'
  s.version     = RailsKmsCredentials::VERSION
  s.authors     = ['Taylor Yelverton']
  s.email       = 'rubygems@yelvert.io'
  s.homepage    = 'https://github.com/ComplyMD/rails_kms_credentials'
  s.summary     = 'Add support for different credentials for different kmss to Rails'
  s.license     = 'MIT'
  s.description = 'Add support for different credentials for different kmss to Rails'
  s.metadata    = {
    'bug_tracker_uri' => 'https://github.com/ComplyMD/rails_kms_credentials/issues',
    'changelog_uri' => 'https://github.com/ComplyMD/rails_kms_credentials/commits/master',
    'documentation_uri' => 'https://github.com/ComplyMD/rails_kms_credentials/wiki',
    'homepage_uri' => 'https://github.com/ComplyMD/rails_kms_credentials',
    'source_code_uri' => 'https://github.com/ComplyMD/rails_kms_credentials',
    'rubygems_mfa_required' => 'true',
  }

  s.files = Dir['lib/**/*','README.md','MIT-LICENSE','rails_kms_credentials.gemspec']

  s.require_paths = %w[ lib ]

  s.required_ruby_version = '>= 2.7.0'

  s.add_dependency('activesupport', '>= 5.0.0', '< 8.0.0')
  s.add_dependency('railties', '>= 5.0.0', '< 8.0.0')

  s.add_dependency('httparty', '~> 0.21.0')
end
