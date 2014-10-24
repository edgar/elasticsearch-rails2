module Elasticsearch
  module Rails2
    module Response

      # Encapsulates the collection of documents returned from Elasticsearch
      #
      # Implements Enumerable and forwards its methods to the {#results} object.
      #
      class Results
        attr_reader :klass, :response

        include Enumerable

        delegate :each, :empty?, :size, :slice, :[], :to_a, :to_ary, to: :results

        # @param klass    [Class] The name of the model class
        # @param response [Hash]  The full response returned from Elasticsearch client
        # @param options  [Hash]  Optional parameters
        #
        def initialize(klass, response, options={})
          @klass     = klass
          @response  = response
        end

        # Returns the {Results} collection
        #
        def results
          @results  = response.response['hits']['hits'].map { |hit| Result.new(hit) }
        end

        # Returns the total number of hits
        #
        def total
          response.response['hits']['total']
        end

        # Returns the max_score
        #
        def max_score
          response.response['hits']['max_score']
        end

        # Returns the hit IDs
        #
        def ids
          response.response['hits']['hits'].map { |hit| hit['_id'] }
        end

      end
    end
  end
end