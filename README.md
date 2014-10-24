# Elasticsearch::Rails2 [![Build Status](https://travis-ci.org/edgar/elasticsearch-rails2.png?branch=master)](https://travis-ci.org/edgar/elasticsearch-rails2) [![Dependency Status](https://gemnasium.com/edgar/elasticsearch-rails2.svg)](https://gemnasium.com/edgar/elasticsearch-rails2)

The `elasticsearch-rails2` library is based on the
[`elasticsearch-model`](https://github.com/elasticsearch/elasticsearch-model) and builds on top of the
the [`elasticsearch`](https://github.com/elasticsearch/elasticsearch-ruby) library.

It aims to simplify integration of [Ruby on Rails](http://rubyonrails.org) 2.3 models (`ActiveRecord`)
with the [Elasticsearch](http://www.elasticsearch.org) search.

([`elasticsearch-model`](https://github.com/elasticsearch/elasticsearch-model) requires Ruby on Rails >= 3.0)

The library is compatible with Ruby 1.9.3.

## Installation

Add this line to your application's Gemfile:

    gem 'elasticsearch-rails2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elasticsearch-rails2

## Usage

Let's suppose you have an `Article` model:

```ruby
require 'elasticsearch/rails2'

class Article < ActiveRecord::Base
  include Elasticsearch::Rails2
end
```

This will extend the model with functionality related to Elasticsearch:

### Elasticsearch client

The module will set up a [client](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch),
connected to `localhost:9200`, by default. You can access and use it as any other `Elasticsearch::Client`:

```ruby
Article.client.cluster.health
# => { "cluster_name"=>"elasticsearch", "status"=>"yellow", ... }
```

To use a client with different configuration, just set up a client for the model:

```ruby
Article.client = Elasticsearch::Client.new host: 'api.server.org'
```

Or configure the client for all models:

```ruby
Elasticsearch::Rails2.client = Elasticsearch::Client.new log: true
```

You might want to do this during you application bootstrap process, e.g. in a Rails initializer.

Please refer to the
[`elasticsearch-transport`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-transport)
library documentation for all the configuration options, and to the
[`elasticsearch-api`](http://rubydoc.info/gems/elasticsearch-api) library documentation
for information about the Ruby client API.

### Searching

For starters, we can try the "simple" type of search:

```ruby
response = Article.search 'fox dogs'

response.took
# => 3

response.results.total
# => 2

response.results.first._score
# => 0.02250402

response.results.first._source.title
# => "Quick brown fox"
```

#### Search results

The returned `response` object is a rich wrapper around the JSON returned from Elasticsearch,
providing access to response metadata and the actual results ("hits").

Each "hit" is wrapped in the `Result` class, and provides method access
to its properties via [`Hashie::Mash`](http://github.com/intridea/hashie).

The `results` object supports the `Enumerable` interface:

```ruby
response.results.map { |r| r._source.title }
# => ["Quick brown fox", "Fast black dogs"]

response.results.select { |r| r.title =~ /^Q/ }
# => [#<Elasticsearch::Model::Response::Result:0x007 ... "_source"=>{"title"=>"Quick brown fox"}}>]
```

In fact, the `response` object will delegate `Enumerable` methods to `results`:

```ruby
response.any? { |r| r.title =~ /fox|dog/ }
# => true
```

To use `Array`'s methods (including any _ActiveSupport_ extensions), just call `to_a` on the object:

```ruby
response.to_a.last.title
# "Fast black dogs"
```

#### Search results as database records

Instead of returning documents from Elasticsearch, the `records` method will return a collection
of model instances, fetched from the primary database, ordered by score:

```ruby
response.records.to_a
# Article Load (0.3ms)  SELECT "articles".* FROM "articles" WHERE "articles"."id" IN (1, 2)
# => [#<Article id: 1, title: "Quick brown fox">, #<Article id: 2, title: "Fast black dogs">]
```

The returned object is the genuine collection of model instances returned by your database,

The `records` method returns the real instances of your model, which is useful when you want to access your
model methods -- at the expense of slowing down your application, of course.
In most cases, working with `results` coming from Elasticsearch is sufficient, and much faster. See the
[`elasticsearch-rails`](https://github.com/elasticsearch/elasticsearch-rails/tree/master/elasticsearch-rails)
library for more information about compatibility with the Ruby on Rails framework.

#### The Elasticsearch DSL

In most situation, you'll want to pass the search definition
in the Elasticsearch [domain-specific language](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl.html) to the client:

```ruby
response = Article.search query:     { match:  { title: "Fox Dogs" } },
                          highlight: { fields: { title: {} } }

response.results.first.highlight.title
# ["Quick brown <em>fox</em>"]
```

You can pass any object which implements a `to_hash` method, or you can use your favourite JSON builder
to build the search definition as a JSON string:

```ruby
require 'jbuilder'

query = Jbuilder.encode do |json|
  json.query do
    json.match do
      json.title do
        json.query "fox dogs"
      end
    end
  end
end

response = Article.search query
response.results.first.title
# => "Quick brown fox"
```

### Index Configuration

By default, index name and document type will be inferred from your class name,
you can set it explicitely, however:

```ruby
class Article
  index_name    "articles-#{Rails.env}"
  document_type "post"
end
```

For `index_name` there is a global setting in case you want to use the same index for all models:

```ruby
Elasticsearch::Rails2.index_name = 'production'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
