module Elasticsearch
  module Rails2
  # Defines constants and methods related to configuration
    module Configuration
      # An array of valid keys in the options hash when configuring Elasticsearch::Rails2
      VALID_OPTIONS_KEYS = [
        :index_name
      ].freeze

      # By default, don't set an index_name
      DEFAULT_INDEX_NAME = nil

      # @private
      attr_accessor *VALID_OPTIONS_KEYS

      # When this module is extended, set all configuration options to their default values
      def self.extended(base)
        base.reset
      end

      # Convenience method to allow configuration options to be set in a block
      def configure
        yield self
      end

      # Create a hash of options and their values
      def options
        VALID_OPTIONS_KEYS.inject({}) do |option, key|
          option.merge!(key => send(key))
        end
      end

      # Reset all configuration options to defaults
      def reset
        self.index_name     = DEFAULT_INDEX_NAME
      end
    end
  end
end