require 'rails'

module RailsKmsCredentials
  class Railtie < Rails::Railtie
    railtie_name :rails_kms_credentials

    rake_tasks do
      load 'tasks/credentials.rake'
    end

  end
end
