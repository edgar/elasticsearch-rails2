require 'spec_helper'

describe Elasticsearch::Rails2::Searching::SearchRequest do
  class ::SearchingDummyModel < ActiveRecord::Base
    include Elasticsearch::Rails2
  end

  before do
    create_dummy_table :searching_dummy_models

    @client = double('client')
    expect(SearchingDummyModel).to receive(:client).and_return(@client)
  end

  context "when the query is an string" do
    it "should pass the search definition as a simple query" do
      expect(@client).to receive(:search).with(hash_including(q: 'foo'))

      search_request = Elasticsearch::Rails2::Searching::SearchRequest.new SearchingDummyModel, 'foo'
      search_request.execute!
    end
  end

  context "when the query is a hash" do
    it "should pass the search definition as a hash" do
      expect(@client).to receive(:search).with(hash_including(body: {foo: 'bar'}))

      search_request = Elasticsearch::Rails2::Searching::SearchRequest.new SearchingDummyModel, {foo: 'bar'}
      search_request.execute!
    end
  end

  context "when the query is a JSON string" do
    it "should pass the search definition as a JSON string" do
      expect(@client).to receive(:search).with(hash_including(body: "{'foo':'bar'}"))

      search_request = Elasticsearch::Rails2::Searching::SearchRequest.new SearchingDummyModel, "{'foo':'bar'}"
      search_request.execute!
    end
  end

  context "when the query responds to_hash" do
    class CustomQuery
      def to_hash; {foo: 'bar'}; end
    end

    it "should pass the search definition as a hash" do
      expect(@client).to receive(:search).with(hash_including(body: {foo: 'bar'}))

      search_request = Elasticsearch::Rails2::Searching::SearchRequest.new SearchingDummyModel, CustomQuery.new
      search_request.execute!
    end
  end

  it "should pass the options to the client" do
    expect(@client).to receive(:search).with(hash_including(q: 'foo', size: 15))

    search_request = Elasticsearch::Rails2::Searching::SearchRequest.new SearchingDummyModel, 'foo', size: 15
    search_request.execute!
  end

end