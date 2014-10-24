module Elasticsearch

  module Rails2
    # Provides methods for getting and setting index name
    #
    module Naming

      module ClassMethods

        # Get or set the name of the index
        #
        # @example Set the index name for the `Building` model
        #
        #     class Building
        #       index_name "buildings-#{Rails.env}"
        #     end
        #
        # @example Set the index name for the `Building` model and re-evaluate it on each call
        #
        #     class Building
        #       index_name { "buildings-#{Time.now.year}" }
        #     end
        #
        # @example Directly set the index name for the `Building` model
        #
        #     Building.index_name "buildings-#{Rails.env}"
        #
        #
        def index_name name=nil, &block
          if name || block_given?
            return (@index_name = name || block)
          end

          if @index_name.respond_to?(:call)
            @index_name.call
          else
            @index_name || Elasticsearch::Rails2.index_name || "#{self.model_name.collection}_index"
          end
        end

        # Set the index name
        #
        # @see index_name
        def index_name=(name)
          @index_name = name
        end

        # Get or set the document type
        #
        # @example Set the document type for the `Building` model
        #
        #     class Building
        #       document_type "my-building"
        #     end
        #
        # @example Directly set the document type for the `Building` model
        #
        #     Building.document_type "my-building"
        #
        def document_type name=nil
          @document_type = name || @document_type || self.model_name.collection
        end


        # Set the document type
        #
        # @see document_type
        #
        def document_type=(name)
          @document_type = name
        end
      end

      module InstanceMethods

        # Get or set the index name for the model instance
        #
        # @example Set the index name for an instance of the `Building` model
        #
        #     @building.index_name "buildings-#{@building.sourceid}"
        #
        #
        def index_name name=nil, &block
          if name || block_given?
            return (@index_name = name || block)
          end

          if @index_name.respond_to?(:call)
            @index_name.call
          else
            @index_name || self.class.index_name
          end
        end

        # Set the index name
        #
        # @see index_name
        def index_name=(name)
          @index_name = name
        end

        # Get or set the document type
        #
        # @example Set the document type for an instance of the `Building` model
        #
        #     @bulding.document_type "my-building"
        #
        #
        def document_type name=nil
          @document_type = name || @document_type || self.class.document_type
        end


        # Set the document type
        #
        # @see document_type
        #
        def document_type=(name)
          @document_type = name
        end
      end

    end
  end
end