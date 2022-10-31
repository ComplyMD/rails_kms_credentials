# frozen_string_literal: true

module RailsKmsCredentials
  class CredentialsConfig < ActiveSupport::OrderedOptions
  end

  module Configuration
    extend ActiveSupport::Concern

    def kms_credentials
      @kms_credentials ||= Rails.application.config_for(:kms_credentials).with_indifferent_access
    end

  end
end
