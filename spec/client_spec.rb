require 'spec_helper'

describe Elasticsearch::Rails2::Client do

  context "Client module" do
    class ::FooClientModule
      include Elasticsearch::Rails2
      # extend Elasticsearch::Rails2::Client::ClassMethods
      # include Elasticsearch::Rails2::Client::InstanceMethods
    end

    context "default client method" do
      it "should be an Elasticsearch::Transport::Client" do
        expect(FooClientModule.client).to be_an Elasticsearch::Transport::Client
        expect(FooClientModule.new.client).to be_an Elasticsearch::Transport::Client
      end
    end

    context "set the client for the model" do
      it "should set the client for the class and for new instances" do
        obj = 'foo'
        FooClientModule.client = obj
        expect(FooClientModule.client).to be obj
        expect(FooClientModule.new.client).to be obj
      end
    end

    context "set the client for an instance" do
      it "should set the client for the instance" do
        obj = 'foo'
        instance = FooClientModule.new
        instance.client = obj
        expect(instance.client).to be obj
      end
    end

  end
end