require 'spec_helper'

describe Elasticsearch::Rails2::Response::Result do

  it "should have method access to properties" do
    result = Elasticsearch::Rails2::Response::Result.new foo: 'bar', bar: { bam: 'baz' }

    expect(result).to respond_to :foo
    expect(result).to respond_to :bar

    expect(result.foo).to eq('bar')
    expect(result.bar.bam).to eq('baz')

    expect{result.xoxo}.to raise_error(NoMethodError)
  end

  it "should return _id as #id" do
    result = Elasticsearch::Rails2::Response::Result.new foo: 'bar', _id: 42, _source: { id: 12 }

    expect(result.id).to eq(42)
    expect(result._source.id).to eq(12)
  end

  it "should return _type as #type" do
    result = Elasticsearch::Rails2::Response::Result.new foo: 'bar', _type: 'baz', _source: { type: 'BAM' }

    expect(result.type).to eq('baz')
    expect(result._source.type).to eq('BAM')
  end

  it "should delegate method calls to `_source` when available" do
    result = Elasticsearch::Rails2::Response::Result.new foo: 'bar', _source: { bar: 'baz' }

    expect(result).to respond_to :foo
    expect(result).to respond_to :_source
    expect(result).to respond_to :bar

    expect(result.foo).to eq('bar')
    expect(result._source.bar).to eq('baz')
    expect(result.bar).to eq('baz')
  end

  it "should delegate existence method calls to `_source`" do
    result = Elasticsearch::Rails2::Response::Result.new foo: 'bar', _source: { bar: { bam: 'baz' } }

    expect(result._source).to respond_to :bar?
    expect(result).to respond_to :bar?

    expect(result._source.bar?).to be true
    expect(result.bar?).to be true
    expect(result.boo?).to be false

    expect(result.bar.bam?).to be true
    expect(result.bar.boo?).to be false
  end

  it "should delegate methods to @result" do
    result = Elasticsearch::Rails2::Response::Result.new foo: 'bar'


    expect(result.foo).to eq('bar')
    expect(result.fetch('foo')).to eq('bar')
    expect(result.fetch('NOT_EXIST', 'moo')).to eq('moo')
    expect(result.keys).to eq(['foo'])

    expect(result).to respond_to :to_hash
    expect(result.to_hash).to eq({'foo' => 'bar'})

    expect{result.does_not_exist}.to raise_error(NoMethodError)
  end

  it "should delegate existence method calls to @result" do
    result = Elasticsearch::Rails2::Response::Result.new foo: 'bar', _source: { bar: 'bam' }
    expect(result).to respond_to :foo?

    expect(result.foo?).to be true
    expect(result.boo?).to be false
    expect(result._source.foo?).to be false
    expect(result._source.boo?).to be false
  end

  it "should delegate as_json to @result even when ActiveSupport changed half of Ruby" do
    require 'active_support/json/encoding'
    result = Elasticsearch::Rails2::Response::Result.new foo: 'bar'

    expect(result.instance_variable_get(:@result)).to receive(:as_json).with(:except => 'foo')
    result.as_json(:except => 'foo')
  end
end