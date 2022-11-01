# frozen_string_literal: true

module RailsKmsCredentials
  module Store
    module AzureKeyVault
      module Client
        class ManagedIdentity < Base
          def get_secrets_list(url)
            HTTParty.get(
              url,
              headers: {
                Authorization: "Bearer #{access_token}",
              },
            )
          end

          def get_secret(url)
            HTTParty.get(
              url,
              headers: {
                Authorization: "Bearer #{access_token}",
              },
            )
          end

          private

            def access_token
              return @access_token if instance_variable_defined?(:@access_token)
              @_access_token_response = HTTParty.get(
                'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net',
                {
                  headers: { Metadata: 'true' },
                }
              )
              raise 'KmsCredentials AzureKeyVault ClientCredentials unable to get access token' unless @_access_token_response.ok?
              @access_token = @_access_token_response['access_token']
            end

        end

        add(:managed_identity, ManagedIdentity)

      end
    end
  end
end
