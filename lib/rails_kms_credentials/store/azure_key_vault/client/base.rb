# frozen_string_literal: true

module RailsKmsCredentials
  module Store
    module AzureKeyVault
      module Client
        class Base
          attr_reader :store

          delegate :config, to: :store

          def initialize(store)
            @store = store
          end

          def get_secrets_list(url)
            raise NotImplementedError
          end

          def get_secret(url)
            raise NotImplementedError
          end

        end
      end
    end
  end
end
