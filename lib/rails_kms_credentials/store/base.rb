# frozen_string_literal: true

module RailsKmsCredentials
  module Store
    module Base
      class Store
        attr_reader :root

        delegate :config, to: :root

        def initialize(root)
          @root = root
        end

        def credentials
          raise NotImplementedError
        end

      end
    end
  end
end
