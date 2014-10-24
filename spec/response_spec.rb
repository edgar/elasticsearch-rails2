require 'spec_helper'

describe Elasticsearch::Rails2::Response do

  class ::ResponseFooModel < ActiveRecord::Base
    include Elasticsearch::Rails2
    index_name :test_index
  end

  RESPONSE = { 'took' => '5', 'timed_out' => false, '_shards' => {'one' => 'OK'}, 'hits' => { 'hits' => [] } }


end