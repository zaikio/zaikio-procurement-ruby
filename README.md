# Zaikio::Procurement

Ruby API Client for Zaikio's Procurement Platform.

## Installation

### 1. Add this line to your application's Gemfile:

```ruby
gem 'zaikio-procurement'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install zaikio-procurement
```

### 2. Configure the gem:

```rb
# config/initializers/zaikio_procurement.rb

Zaikio::Procurement.configure do |config|
  config.environment = :production # sandbox or production
end
```


## Usage

The Procurement Client has an ORM like design.

For the requests to work, a valid JSON Web token with the correct OAuth Scopes must always be provided. Please refer to [zakio-oauth_client](https://github.com/zaikio/zaikio-oauth_client).

If you want to know which actions are available and which scopes are required, please refer to the [Procurement Consumer API Reference](https://docs.zaikio.com/api/procurement_consumers/procurement.html).

### As an organization

```rb
token = "..." # Your valid JWT for an organization
Zaikio::Procurement.with_token(token) do

  # Fetch Data
  Zaikio::Procurement::Article.all
  Zaikio::Procurement::Article.find("7cbf51bd-35a8-47a1-84a2-57aa63140234")
  Zaikio::Procurement::Article.list_by_article_type_or_supplier_slug("great_paper_company")

  # Associations
  article = Zaikio::Procurement::Article.find("7cbf51bd-35a8-47a1-84a2-57aa63140234")
  article.supplier
  article.variants

  # Search for all variants of a substrate
  search = Zaikio::Procurement::SubstrateSearch.new("Magno", grain: "long", paper_weight: 80)

  # or by providing a supplier_id to search for all variants of a substrate of from a specific supplier
  search = Zaikio::Procurement::SubstrateSearch.new("Magno", grain: "long", paper_weight: 80, supplier_id: "a8b99fd3-a790-4366-85b0-2df4af0ca000")

  search.results # Returns a list of matching variants
  search.facets # Returns a list of search facets that can be used to further narrow down the results
end
```

### Error Handling

If an unexpected error occurs with an API call (i.e. an error that has no status code `2xx`, `404` or `422`) then a `Zaikio::ConnectionError` is thrown automatically (for `404` there will be a `Zaikio::ResourceNotFound`).

This can be easily caught using the `with_fallback` method. We recommend to always work with fallbacks.

```rb
Zaikio::Directory.with_token(token) do
  Zaikio::Procurement::Article.with_fallback.find("7cbf51bd-35a8-47a1-84a2-57aa63140234") # => nil
  Zaikio::Procurement::Article.with_fallback.all # Automatically uses empty array as fallback
end
```