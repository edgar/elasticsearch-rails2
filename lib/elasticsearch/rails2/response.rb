module Elasticsearch
  module Rails2
    # Contains modules and classes for wrapping the response from Elasticsearch
    #
    module Response

      # Encapsulate the response returned from the Elasticsearch client
      #
      # Implements Enumerable and forwards its methods to the {#results} object.
      #
      class Response
        attr_reader :klass, :search, :response,
                    :took, :timed_out, :shards

        include Enumerable

        delegate :each, :empty?, :size, :slice, :[], :to_ary, to: :results

        def initialize(klass, search, options={})
          @klass     = klass
          @search    = search
        end

        # Returns the Elasticsearch response
        #
        # @return [Hash]
        #
        def response
          @response ||= begin
            Hashie::Mash.new(search.execute!)
          end
        end

        # Returns the collection of "hits" from Elasticsearch
        #
        # @return [Results]
        #
        def results
          @results ||= Results.new(klass, self)
        end

        # Returns the collection of records from the database
        #
        # @return [Records]
        #
        def records
          @records ||= Records.new(klass, self)
        end

        # Returns the "took" time
        #
        def took
          response['took']
        end

        # Returns whether the response timed out
        #
        def timed_out
          response['timed_out']
        end

        # Returns the statistics on shards
        #
        def shards
          Hashie::Mash.new(response['_shards'])
        end

        # Returns whether the response scroll id
        #
        def scroll_id
          response['_scroll_id']
        end

      end
    end
  end
end