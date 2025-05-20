# frozen_string_literal: true

module RailsKmsCredentials
  module Store
    module LocalFileKeyVault

      class Store < Base::Store
        attr_reader :vault, :file_path, :secret_prefix, :loaded

        EMPTY_VALUE = '--EMPTY--'

        def initialize(*) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          super
          @file_path = Rails.root.join('config', 'kms_credentials_local_file_key_vault.yml')
          raise 'Missing KmsCredentials local file vault' unless File.exist?(@file_path)
          @secret_prefix = case config['client']['secret_prefix']
                           when true
                             Rails.application.class.name.split('::').first.underscore.dasherize
                           when String
                            config['client']['secret_prefix']
                           end
          @_secret_prefix = @secret_prefix.present? ? Regexp.new("^#{@secret_prefix}----") : ''
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
                raise "KmsCredentials local file vault credentials format issue: #{secret['name']}"
              end
              h[key] ||= ActiveSupport::OrderedOptions.new
            end
            parent[name.last] = secret['value'] == EMPTY_VALUE ? '' : secret['value']
          end
        end

        private

          def load_secrets
            return if @loaded
            load_secrets_from_file
          end

          def load_secrets_from_file
            @_secrets ||= {}
            secrets_data = YAML.load_file(@file_path)
            secrets_data.each do |key, value|
              secret_name = key.to_s
              next unless secret_name =~ @_secret_prefix
              @_secrets[secret_name] = { 'name' => secret_name, 'value' => value }
            end
            @loaded = true
          end

      end
    end

    add(:local_file_key_vault, LocalFileKeyVault::Store)

  end
end