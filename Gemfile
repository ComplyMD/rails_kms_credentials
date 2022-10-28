# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gemspec

group :test do
  gem 'faker'
  gem 'rspec'
  gem 'rspec-simplecov', require: false
  gem 'rubocop'
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
end

group :development do
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-nav'
  gem 'pry-remote'
end
