# frozen_string_literal: true

module RailsKmsCredentials
  class Credentials
    attr_reader :config, :store

    def initialize(config)
      @config = config
      @_store_klass = Store.get config['store']
      @store = @_store_klass.new self
    end

  end
end
