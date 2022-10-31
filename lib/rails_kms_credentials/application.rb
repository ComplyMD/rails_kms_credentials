# frozen_string_literal: true

module RailsKmsCredentials
  module Application
    extend ActiveSupport::Concern

    included do
      def credentials
        kms_credentials.store.credentials
      end

      def kms_credentials
        @kms_credentials ||= Credentials.new(config.kms_credentials)
      end
    end

  end
end
