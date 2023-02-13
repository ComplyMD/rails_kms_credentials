# frozen_string_literal: true

module RailsKmsCredentials
  module Store
    module AzureKeyVault
      module Client
        class AksWorkloadIdentity < Base
          ENV_AUTHORITY_HOST = 'AZURE_AUTHORITY_HOST'
          ENV_CLIENT_ID = 'AZURE_CLIENT_ID'
          ENV_FEDERATED_TOKEN_FILE = 'AZURE_FEDERATED_TOKEN_FILE'
          ENV_TENANT_ID = 'AZURE_TENANT_ID'

          
          attr_reader :authority_host, :client_id, :federated_token_file, :tenant_id

          def initialize(*)
            super
            @authority_host = ENV[ENV_AUTHORITY_HOST]
            raise 'Missing KmsCredentials AzureKeyVault AksWorkloadIdentity authority_host' if authority_host.blank?
            @client_id = ENV[ENV_CLIENT_ID]
            raise 'Missing KmsCredentials AzureKeyVault AksWorkloadIdentity client_id' if @client_id.blank?
            @federated_token_file = ENV[ENV_FEDERATED_TOKEN_FILE]
            raise 'Missing KmsCredentials AzureKeyVault AksWorkloadIdentity federated_token_file' if @federated_token_file.blank?
            raise "Missing KmsCredentials AzureKeyVault AksWorkloadIdentity federated_token_file does not exist: `#{@federated_token_file}`" unless File.exist?(@federated_token_file)
            @tenant_id = ENV[ENV_TENANT_ID]
            raise 'Missing KmsCredentials AzureKeyVault AksWorkloadIdentity tenant_id' if @tenant_id.blank?
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

            def client_assertion
              @client_assertion ||= File.read(@federated_token_file)
            end

            def access_token
              return @access_token if instance_variable_defined?(:@access_token)
              @_access_token_response = HTTParty.post(
                "#{authority_host}#{tenant_id}/oauth2/v2.0/token",
                {
                  body: {
                    client_assertion: client_assertion,
                    client_assertion_type: 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer',
                    client_id: client_id,
                    scope: 'https://vault.azure.net/.default',
                    grant_type: 'client_credentials',
                  }
                }
              )
              raise 'KmsCredentials AzureKeyVault AksWorkloadIdentity unable to get access token' unless @_access_token_response.ok?
              @access_token = @_access_token_response['access_token']
            end

        end

        add(:aks_workload_identity, AksWorkloadIdentity)

      end
    end
  end
end
