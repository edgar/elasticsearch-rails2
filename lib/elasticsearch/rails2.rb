require 'elasticsearch'

require 'hashie'
require 'active_support'
require 'active_record'

require "elasticsearch/rails2/version"
require "elasticsearch/rails2/configuration"
require "elasticsearch/rails2/client"
require "elasticsearch/rails2/naming"
require "elasticsearch/rails2/searching"
require "elasticsearch/rails2/response"
require "elasticsearch/rails2/response/result"
require "elasticsearch/rails2/response/results"

module Elasticsearch
  module Rails2

    def self.included(base)
      base.send :include, Elasticsearch::Rails2::Client::InstanceMethods
      base.extend Elasticsearch::Rails2::Client::ClassMethods

      base.send :include, Elasticsearch::Rails2::Naming::InstanceMethods
      base.extend Elasticsearch::Rails2::Naming::ClassMethods

      base.extend Elasticsearch::Rails2::Searching::ClassMethods
    end

    module ClassMethods
      # Get the client common for all models
      #
      # @example Get the client
      #
      #     Elasticsearch::Model.client
      #     => #<Elasticsearch::Transport::Client:0x007f96a7d0d000 @transport=... >
      #
      def client
        @client ||= Elasticsearch::Client.new
      end

      # Set the client for all models
      #
      # @example Configure (set) the client for all models
      #
      #     Elasticsearch::Model.client Elasticsearch::Client.new host: 'http://localhost:9200', tracer: true
      #     => #<Elasticsearch::Transport::Client:0x007f96a6dd0d80 @transport=... >
      #
      # @note You have to set the client before you call Elasticsearch methods on the model,
      #       or set it directly on the model; see {Elasticsearch::Model::Client::ClassMethods#client}
      #
      def client=(client)
        @client = client
      end

      def options=(options={})
        Configuration::VALID_OPTIONS_KEYS.each do |key|
          send("#{key}=", options[key])
        end
      end
    end
    extend ClassMethods
    extend Configuration
  end
end
