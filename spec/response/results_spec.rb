require 'spec_helper'

describe Elasticsearch::Rails2::Response::Results do
  context "Response results" do
    class ::ResultsDummyModel < ActiveRecord::Base
      include Elasticsearch::Rails2
    end

    before do
      create_dummy_table :results_dummy_models

      @els_response = { 'hits' => { 'total' => 123, 'max_score' => 456, 'hits' => [{'foo' => 'bar'}] } }

      @search   = Elasticsearch::Rails2::Searching::SearchRequest.new ResultsDummyModel, '*'
      allow(@search).to receive(:execute!){@els_response}
      @response = Elasticsearch::Rails2::Response::Response.new ResultsDummyModel, @search
      @results  = Elasticsearch::Rails2::Response::Results.new  ResultsDummyModel, @response
    end

    it "should access the results" do
      expect(@results).to respond_to :results
      results_results = @results.results
      expect(results_results.size).to eq 1
      expect(results_results.first.foo).to eq 'bar'
    end

    it "should delegate Enumerable methods to results" do
      expect(@results).to_not be_empty
      expect(@results.first.foo).to eq 'bar'
    end

  end
end