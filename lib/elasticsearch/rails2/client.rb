module Elasticsearch
  module Rails2
    module Client
      # Contains an `Elasticsearch::Client` instance
      #
      module ClassMethods

        # Get the client for a specific model class
        #
        # @example Get the client for `Building` and perform API request
        #
        #     Building.client.cluster.health
        #     # => { "cluster_name" => "elasticsearch" ... }
        #
        def client
          @client ||= Elasticsearch::Rails2.client
        end

        # Set the client for a specific model class
        #
        # @example Configure the client for the `Building` model
        #
        #     Building.client = Elasticsearch::Client.new host: 'http://api.server:8080'
        #     Building.search ...
        #
        def client=(client)
          @client = client
        end
      end

      module InstanceMethods

        # Get or set the client for a specific model instance
        #
        # @example Get the client for a specific record and perform API request
        #
        #     @building = Building.first
        #     @building.client.info
        #     # => { "name" => "Node-1", ... }
        #
        def client
          @client ||= self.class.client
        end

        # Set the client for a specific model instance
        #
        # @example Set the client for a specific record
        #
        #     @building = Building.first
        #     @building.client = Elasticsearch::Client.new host: 'http://api.server:8080'
        #
        def client=(client)
          @client = client
        end
      end
    end
  end
end