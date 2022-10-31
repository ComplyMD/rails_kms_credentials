# frozen_string_literal: true

module RailsKmsCredentials
  module Store
    @map = {}.with_indifferent_access

    class << self
      attr_reader :map

      def get(store)
        map[store] || raise("KmsCredentials unknown store: `#{store}`")
      end

      def add(name, klass)
        map[name] = klass
      end

    end

  end
end

require 'rails_kms_credentials/store/base'
require 'rails_kms_credentials/store/azure_key_vault'
