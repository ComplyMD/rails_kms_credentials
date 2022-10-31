# frozen_string_literal: true

# Container Module
module RailsKmsCredentials; end

require 'active_support/concern'

require 'rails_kms_credentials/application'
require 'rails_kms_credentials/configuration'
require 'rails_kms_credentials/credentials'
require 'rails_kms_credentials/store'
require 'rails_kms_credentials/railtie'
require 'rails_kms_credentials/version'

Rails::Application::Configuration.send(:include, RailsKmsCredentials::Configuration)
Rails::Application.send(:include, RailsKmsCredentials::Application)