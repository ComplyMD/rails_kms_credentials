# frozen_string_literal: true

module RailsKmsCredentials
  module Store
    module AzureKeyVault
      module Client
        @map = {}.with_indifferent_access

        class << self
          attr_reader :map

          def get(client)
            map[client] || raise("KmsCredentials AzureKeyVault unknown client: `#{client}`")
          end

          def add(name, klass)
            map[name] = klass
          end

        end

      end
    end
  end
end

require 'rails_kms_credentials/store/azure_key_vault/client/base'
require 'rails_kms_credentials/store/azure_key_vault/client/aks_workload_identity'
require 'rails_kms_credentials/store/azure_key_vault/client/client_credentials'
require 'rails_kms_credentials/store/azure_key_vault/client/managed_identity'
require 'rails_kms_credentials/store/azure_key_vault/client/env_access_token'
