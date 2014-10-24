require 'spec_helper'

describe Elasticsearch::Rails2 do

  after do
    Elasticsearch::Rails2.reset
  end

  describe ".client" do
    it "should return a default Elasticsearch::Transport::Client" do
      expect(Elasticsearch::Rails2.client).to be_an Elasticsearch::Transport::Client
    end
  end

  describe ".client=" do
    it "should set the client" do
      obj = 'foo'
      Elasticsearch::Rails2.client = obj
      expect(Elasticsearch::Rails2.client).to be obj
    end
  end

  describe '.index_name' do
    it "should return the default index_name" do
      expect(Elasticsearch::Rails2.index_name).to eq(Elasticsearch::Rails2::Configuration::DEFAULT_INDEX_NAME)
    end
  end

  describe '.index_name=' do
    it "should set the index_name" do
      Elasticsearch::Rails2.index_name = 'production'
      expect(Elasticsearch::Rails2.index_name).to eq('production')
    end
  end

  describe '.options=' do
    before do
      @keys = Elasticsearch::Rails2::Configuration::VALID_OPTIONS_KEYS

      @options = {
        :index_name => 'production'
      }
    end

    it "should override default configuration" do
      Elasticsearch::Rails2.options = @options
      @keys.each do |key|
        expect(Elasticsearch::Rails2.send(key)).to eq(@options[key])
      end
    end
  end

end
