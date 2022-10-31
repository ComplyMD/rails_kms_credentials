# frozen_string_literal: true

module RailsKmsCredentials
  module Store
    module AzureKeyVault
      module Client
        class ClientCredentials < Base
          attr_reader :tenant_id, :client_id, :client_secret

          def initialize(*)
            super
            @tenant_id = client_config['tenant_id']
            raise 'Missing KmsCredentials AzureKeyVault ClientCredentials tenant_id' if tenant_id.blank?
            @client_id = client_config['client_id']
            raise 'Missing KmsCredentials AzureKeyVault ClientCredentials client_id' if client_id.blank?
            @client_secret = client_config['client_secret']
            raise 'Missing KmsCredentials AzureKeyVault ClientCredentials client_secret' if client_secret.blank?
          end

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

            def client_config
              config['client']
            end

            def access_token
              return @access_token if instance_variable_defined?(:@access_token)
              @_access_token_response = HTTParty.post(
                "https://login.microsoftonline.com/#{client_config['tenant_id']}/oauth2/v2.0/token",
                {
                  body: {
                    client_id: client_config['client_id'],
                    client_secret: client_config['client_secret'],
                    scope: 'https://vault.azure.net/.default',
                    grant_type: 'client_credentials',
                  }
                }
              )
              raise 'KmsCredentials AzureKeyVault ClientCredentials unable to get access token' unless @_access_token_response.ok?
              @access_token = @_access_token_response['access_token']
            end

        end

        add(:client_credentials, ClientCredentials)

      end
    end
  end
end
