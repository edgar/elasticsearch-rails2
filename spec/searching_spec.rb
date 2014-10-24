require 'spec_helper'

describe Elasticsearch::Rails2::Searching do
  class ::SearchingDummyModel < ActiveRecord::Base
    include Elasticsearch::Rails2
  end

  before do
    create_dummy_table :searching_dummy_models
  end

  it "should have the search method" do
    expect(SearchingDummyModel).to respond_to :search
  end

  it "should have the scan_all_ids method" do
    expect(SearchingDummyModel).to respond_to :scan_all_ids
  end

  describe ".search" do
    it "should initialize the search request object" do
      expect(Elasticsearch::Rails2::Searching::SearchRequest).to receive(:new)
        .with(SearchingDummyModel, 'foo', {default_operator: 'AND'})

      SearchingDummyModel.search 'foo', default_operator: 'AND'
    end

    it "should not execute the actual search" do
      # the search is executed when the response is accessed
      search_request = double('search_request')
      allow(Elasticsearch::Rails2::Searching::SearchRequest).to receive(:new).and_return(search_request)
      expect(search_request).to_not receive(:execute!)
      SearchingDummyModel.search 'foo'
    end
  end
end