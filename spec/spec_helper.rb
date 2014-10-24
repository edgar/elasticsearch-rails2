RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'

exit(0) if RUBY_1_8

$:.unshift File.dirname(__FILE__) + '/../lib'

require 'elasticsearch/rails2'
require 'rspec'
require 'support/active_record'

RSpec.configure do |config|
  config.before(:each) {@dummy_tables = []}
  config.after(:each) {drop_dummy_tables}
end

def create_dummy_table(table_name)
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Migration.create_table table_name do |t|
    t.string :name
  end
  @dummy_tables << table_name
end

def drop_dummy_tables
  ActiveRecord::Migration.verbose = false
  @dummy_tables.each {|table_name| ActiveRecord::Migration.drop_table table_name}
end
