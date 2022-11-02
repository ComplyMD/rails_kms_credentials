# frozen_string_literal: true

module RailsKmsCredentials
  module Store
    module AzureKeyVault

      class Store < Base::Store
        attr_reader :vault, :vault_url, :client, :secret_prefix, :loaded

        SECRETS_API_VERSION = '7.3'

        EMPTY_VALUE = '--EMPTY--'

        def initialize(*) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          super
          @vault = config['vault']
          raise 'Missing KmsCredentials AzureKeyVault vault' if vault.blank?
          raise "Invalid KmsCredentials AzureKeyVault vault `#{vault}`" if vault =~ /[^0-9a-zA-Z\-]/
          @vault_url = "https://#{vault}.vault.azure.net"
          raise 'Missing KmsCredentials AzureKeyVault client' unless config['client'].is_a? Hash
          raise 'Missing KmsCredentials AzureKeyVault client.type' if config['client']['type'].blank?
          @_client_klass = Client.get config['client']['type']
          @client = @_client_klass.new self
          @secret_prefix =  case config['client']['secret_prefix']
                            when true
                              Rails.application.class.parent.to_s.underscore.dasherize
                            when String
                              config['client']['secret_prefix']
                            end
          @_secret_prefix = @secret_prefix ? Regexp.new("^#{@secret_prefix}----") : ''
          @loaded = false
        end

        def credentials # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          return @credentials if instance_variable_defined?(:@credentials)
          load_secrets
          @credentials = @_secrets.values.each_with_object(ActiveSupport::OrderedOptions.new) do |secret, memo|
            name = secret['name'].remove(@_secret_prefix).split('--')
            name.each { |x| x.gsub!('-', '_') }
            parent = name[0..-2].inject(memo) do |h, key|
              if h.key?(key) && !h[key].is_a?(ActiveSupport::OrderedOptions)
                raise "KmsCredentials AzureKeyVault credentials format issue: #{secret['name']}"
              end
              h[key] ||= ActiveSupport::OrderedOptions.new
            end
            parent[name.last] = secret['value'] == EMPTY_VALUE ? '' : secret['value']
          end
        end

        private

          def load_secrets
            return if @loaded
            load_secrets_list
          end

          def load_secrets_list(url = nil) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
            @_get_secrets_list_responses ||= []
            @_secrets ||= {}
            url ||= "#{vault_url}/secrets?api-version=#{SECRETS_API_VERSION}"
            response = client.get_secrets_list url
            @_get_secrets_list_responses << response
            raise "KmsCredentials AzureKeyVault unable to get list of secrets: #{url}" unless response.ok?
            response['value'].each do |secret|
              secret_name = secret['id'].split('/').last
              next unless secret_name =~ @_secret_prefix
              secret['name'] = secret_name
              @_secrets[secret_name] = secret
              load_secret secret_name
            end
            if response['nextLink']
              load_secrets_list(response['nextLink'])
            else
              @loaded = true
            end
          end

          def load_secret(secret_name)
            @_get_secret_responses ||= {}
            return unless (secret = @_secrets[secret_name])
            response = client.get_secret "#{secret['id']}?api-version=#{SECRETS_API_VERSION}"
            @_get_secret_responses[secret_name] = response
            raise "KmsCredentials AzureKeyVault unable to get secret: #{secret['id']}" unless response.ok?
            secret['value'] = response['value']
          end

      end
    end

    add(:azure_key_vault, AzureKeyVault::Store)

  end
end

require 'rails_kms_credentials/store/azure_key_vault/client'
