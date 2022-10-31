# frozen_string_literal: true

module RailsKmsCredentials
  module Store
    module AzureKeyVault
      module Client
        class ManagedIdentity < Base
          def get_secrets_list(url)
            HTTParty.get url
          end

          def get_secret(url)
            HTTParty.get url
          end

        end

        add(:managed_identity, ManagedIdentity)

      end
    end
  end
end
