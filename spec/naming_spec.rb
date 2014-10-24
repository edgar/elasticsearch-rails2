require 'spec_helper'

describe Elasticsearch::Rails2::Naming do
  context "Naming module" do
    class ::NamingDummyModel < ActiveRecord::Base
      include Elasticsearch::Rails2
    end

    before(:each){create_dummy_table :naming_dummy_models}

    describe "index_name" do
      context "Elasticsearch::Rails2.index_name is not defined" do
        it "should return default index_name" do
          expect(NamingDummyModel.index_name).to eq("naming_dummy_models_index")
          expect(NamingDummyModel.new.index_name).to eq("naming_dummy_models_index")
        end
      end

      context "Elasticsearch::Rails2.index_name is defined" do

        before(:each) {Elasticsearch::Rails2.index_name = 'foo'}
        after(:each) {Elasticsearch::Rails2.reset}

        it "should return the Elasticsearch::Rails2.index_name" do
          expect(NamingDummyModel.index_name).to eq("foo")
          expect(NamingDummyModel.new.index_name).to eq("foo")
        end
      end

      context "when the index_name is defined in the class" do
        before(:each){ NamingDummyModel.index_name = 'foobar'}
        after(:each){ NamingDummyModel.index_name = nil}

        it "should return the index_name defined in the class" do
          expect(NamingDummyModel.index_name).to eq("foobar")
          expect(NamingDummyModel.new.index_name).to eq("foobar")
        end

      end


      context "when the index_name is defined for an instance" do
        before(:each){
          @foo = NamingDummyModel.new
          @foo.index_name = 'foobar_instance'
        }

        it "should return the index_name defined in the instance" do
          expect(NamingDummyModel.index_name).to eq("naming_dummy_models_index")
          expect(@foo.index_name).to eq("foobar_instance")
        end

      end

    end

    describe "document_type" do

      it "should return the default calculated document_type" do
        expect(NamingDummyModel.document_type).to eq("naming_dummy_models")
        expect(NamingDummyModel.new.document_type).to eq("naming_dummy_models")
      end

      context "when document_type is defined in the class" do
        before(:each){ NamingDummyModel.document_type = 'foobar'}
        after(:each){ NamingDummyModel.document_type = nil}

        it "should return the new document_type" do
          expect(NamingDummyModel.document_type).to eq("foobar")
          expect(NamingDummyModel.new.document_type).to eq("foobar")
        end
      end

      context "when document_type is defined in the instance" do
        before(:each){
          @foo = NamingDummyModel.new
          @foo.document_type = 'foobar_instance'
        }

        it "should return the new document_type" do
          expect(NamingDummyModel.document_type).to eq("naming_dummy_models")
          expect(@foo.document_type).to eq("foobar_instance")
        end
      end

    end
  end
end