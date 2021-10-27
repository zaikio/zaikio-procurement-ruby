# Zaikio::Procurement

Ruby API Client for Zaikio's Procurement Platform.

> **WARNING**: **Breaking cahnge for Supplier API** - 
> One must provide article `type` in addition to `id` for `Variant.find`.
> See example below.

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
  search = Zaikio::Procurement::SubstrateSearch.new("Magno", grain: "long", paper_weight: 80, supplier_id: "b5b14aa0-ae84-452b-9719-a38545365902")

  search.results # Returns a list of matching variants
  search.facets # Returns a list of search facets that can be used to further narrow down the results

  # https://docs.zaikio.com/api/procurement_consumers/procurement.html#/LineItemSuggestions/post_variants__variant_id__line_item_suggestions
  variant = Zaikio::Procurement::Variant.find("845a4d7e-db5a-46a6-9d30-bf2e884cb393")
  variant.line_item_suggestion(amount: 10, unit: "sheet") # Returns a line item suggestion for a specifc variant

  # in Supplier API one must provide article type when calling `find` on variant:
  # https://docs.zaikio.com/api/procurement_suppliers/procurement.html#/Variants/get__article_type__variants__variant_id_
  variant = Zaikio::Procurement::Variant.find("845a4d7e-db5a-46a6-9d30-bf2e884cb393", type: "substrate")
  variant.skus
  
  # https://docs.zaikio.com/api/procurement_consumers/procurement.html#/LineItemSuggestions/post_suppliers__supplier_id__line_item_suggestions
  supplier = Zaikio::Procurement::Supplier.find("b5b14aa0-ae84-452b-9719-a38545365902")
  supplier.line_item_suggestions(
    variants: [
      {
        id: "0001b94e-4e87-4ee9-8b14-6ff9910b4f26",
        amount: 2000,
        exact_amount: false,
        environmental_certification: "FSC Mix Credit",
        unit: "sheet"
      },
      {
        id: "10236394-ecd4-465b-ab72-0fbd79296e6a",
        amount: 10,
        exact_amount: false,
        environmental_certification: "PEFC 100%",
        unit: "sheet"
      }
    ]
  ) # Returns line item suggestions for multiple variants of a supplier


  # Create new resources
  Zaikio::Procurement::Order.create(
    contract_id: "fd677fc7-abd9-460c-b086-34de1a8349e8",
    delivery_mode: "complete",
    exclusive_sales_group_id: "42dcbaf6-e557-4423-96bc-707ebbc223c0",
    references: ["CO/XXXXXX"],
    state_event: "place",
    deliveries_attributes: [
      {
        address_addressee: "Joey’s Print Ltd",
        address_text: "Emmerich-Josef-Straße 1A, 55116 Mainz",
        desired_delivery_date: "2021-01-29",
        references: ["D/XXXXXX"]
      }
    ],
    order_line_items_attributes: [
      {
        sku_id: "26b3aadc-928f-4d1a-ba2d-13ac3c8f523d",
        amount: 108000
      }
    ]
  )

  order = Zaikio::Procurement::Order.find("86b4a0c5-6d54-4702-a059-da258643f260")
  order.order_line_items.create(sku_id: "6535eeb0-45c2-4c63-8cb9-4814562bb875", amount: 68000)

  # Update resources
  line_item = Zaikio::Procurement::OrderLineItem.find("058a5513-925e-4d0c-923d-fa1ed4bfb3ce")
  line_item.update(amount: 69000)

  # Deleting resources
  line_item = Zaikio::Procurement::OrderLineItem.find("2f5a99c2-9734-4aac-9cee-911b061d3a5a")
  line_item.destroy
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
