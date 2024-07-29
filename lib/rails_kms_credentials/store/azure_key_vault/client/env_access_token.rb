# frozen_string_literal: true

module RailsKmsCredentials
  module Store
    module AzureKeyVault
      module Client
        class EnvAccessToken < Base
          def initialize(*)
            super
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

            def access_token
              return @access_token if instance_variable_defined?(:@access_token)
              @access_token = ENV['AZURE_KEY_VAULT_ACCESS_TOKEN']

              raise 'KmsCredentials AzureKeyVault EnvAccessToken unable to get access token' unless @access_token
              @access_token
            end

        end

        add(:env_access_token, EnvAccessToken)

      end
    end
  end
end
