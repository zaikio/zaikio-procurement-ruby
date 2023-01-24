# Zaikio::Procurement

Ruby API Client for Zaikio's Procurement Consumer Platform.

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

For the requests to work, a valid JSON Web token with the correct OAuth Scopes must always be provided. Please refer to [zaikio-oauth_client](https://github.com/zaikio/zaikio-oauth_client).

If you want to know which actions are available and which scopes are required, please refer to the [Procurement Consumer API V2 Reference](https://docs.zaikio.com/api/procurement_consumers/consumers_v2.html).

### As an organization

```rb
token = "..." # Your valid JWT for an organization
Zaikio::Procurement.with_token(token) do

  # Fetch Data
  Zaikio::Procurement::MaterialRequirement.all
  Zaikio::Procurement::MaterialRequirement.find("7cbf51bd-35a8-47a1-84a2-57aa63140234")

  # Associations
  material_requirement = Zaikio::Procurement::MaterialRequirement.find("7cbf51bd-35a8-47a1-84a2-57aa63140234")
  material_requirement.availability
  material_requirement.pricing
  material_requirement.order

  # Search for a variant
  search = Zaikio::Procurement::VariantSearch.new(type: "sheet_substrate", query: "Soap", grain: "short", paper_weight: 80)
  # You can either pass a single value or a comma separated list of types, e.g. type: "sheet_substrate,plate"
  # Use all to include all available Variant types in the response

  search.results # Returns a list of matching variants
  search.available_filters # Returns a list of available filters that can be used to further narrow down the results

  # Filter and search material requirements
  # Available filters can be found here:  https://docs.zaikio.com/api/procurement_consumers/consumers_v2.html#/MaterialRequirements/get_material_requirements
  Zaikio::Procurement::MaterialRequirement.where(query: "Sappi", filters: { article_category: "sheet_substrate", status: "ordered" })

  ### Create new resources

  # Create a ContractRequest
  supplier = Zaikio::Procurement::Supplier.find("5fd82941-ba2f-4d0b-971a-7050fbbafcef")
  supplier.contract_requests.create(
    customer_number: "1968353479",
    contact_first_name: "Frank",
    contact_last_name: "Gallikanokus",
    contact_email: "fgalli@example.com",
    contact_phone: "+3333333333333",
    references: ["my reference"])

  # Create a MaterialRequirement
  Zaikio::Procurement::MaterialRequirement.create(
    amount: 200,
    job_client: "Awesome Client",
    job_description: "Awesome print product",
    job_link: "https://www.example.com",
    job_reference: "my job reference",
    material_required_at: "2022-08-03",
    supplier_id: "b2a0f1ab-7610-451e-acc7-633284300521",
    variant_id: "31924842-b38b-47b2-90b0-68f8f42f37d6",
    references: ["my requirement reference"],
    visible_in_web: true)

  # Create an Order
  Zaikio::Procurement::Order.create(
    material_requirement_ids: ["9f98e841-1502-4d7b-9b8a-0cf9b8072875"],
    references: ["my order reference"],
    copy_material_requirement_references_to_line_items: true)

  ### Update resources
  material_requirement = Zaikio::Procurement::MaterialRequirement.find("058a5513-925e-4d0c-923d-fa1ed4bfb3ce")
  material_requirement.update(amount: 1000)

  ### Deleting resources
  material_requirement = Zaikio::Procurement::MaterialRequirement.find("2f5a99c2-9734-4aac-9cee-911b061d3a5a")
  material_requirement.destroy

  ### Custom methods

  # Placing an order and submitting it to the supplier
  order = Zaikio::Procurement::Order.find("8eaeb37a-d7aa-424a-aac1-1ade4b4030e2")
  order.place

  # Cancel a placed order
  order = Zaikio::Procurement::Order.find("3d36c6c5-b979-4073-8fcc-78a6cf1bc8bd")
  order.cancel

  # Archive a canceled or completed material requirement
  material_requirement = Zaikio::Procurement::MaterialRequirement.find("2f5a99c2-9734-4aac-9cee-911b061d3a5a")
  material_requirement.archive

  # Refreshing the order conditions (price, stock and delivery date) of the material requirement
  material_requirement = Zaikio::Procurement::MaterialRequirement.find("2f5a99c2-9734-4aac-9cee-911b061d3a5a")
  material_requirement.refresh
end
```

### Error Handling

If an unexpected error occurs with an API call (i.e. an error that has no status code `2xx`, `404` or `422`) then a `Zaikio::ConnectionError` is thrown automatically (for `404` there will be a `Zaikio::ResourceNotFound`).

This can be easily caught using the `with_fallback` method. We recommend to always work with fallbacks.

```rb
Zaikio::Directory.with_token(token) do
  Zaikio::Procurement::MaterialRequirement.with_fallback.find("7cbf51bd-35a8-47a1-84a2-57aa63140234") # => nil
  Zaikio::Procurement::MaterialRequirement.with_fallback.all # Automatically uses empty array as fallback
end
```
