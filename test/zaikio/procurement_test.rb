require "test_helper"

class Zaikio::ProcurementTest < ActiveSupport::TestCase
  def setup
    Zaikio::Procurement.configure do |config|
      config.environment = :test
    end
  end

  def token
    "eyJraWQiOiIwYTlhNmZkMjRlMjIyZmU5NjgwMTNkOWQyOWY2N2U0ZGJlYTE2NzIzNTk3NzY3M2FiNDZhZmYxNjE2NjI3NzliIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJaQUkiLCJzdWIiOiJPcmdhbml6YXRpb24vNWU0ODM4M2QtYjI3Ni00ZDcwLWI2OTAtOWUyMDMyZTNjZDNhIiwiYXVkIjpbImtleWxpbmVfY2xhc3NpYyJdLCJqdGkiOiJmMDQ2ODM3My1hYTRkLTRlYTUtOTgwMS1lYzMzMTFiNjMxZGMiLCJuYmYiOjE2MTEwNjQ3NDYsImV4cCI6MTYxMTA2ODM0Niwiamt1IjoiaHR0cHM6Ly9odWIuc2FuZGJveC56YWlraW8uY29tL2FwaS92MS9qd3RfcHVibGljX2tleXMiLCJzY29wZSI6WyJkaXJlY3Rvcnkub3JnYW5pemF0aW9uLnIiLCJwcm9jdXJlbWVudF9jb25zdW1lci5jYXRhbG9nLnIiLCJwcm9jdXJlbWVudF9jb25zdW1lci5jb250cmFjdHMucnciLCJwcm9jdXJlbWVudF9jb25zdW1lci5vcmRlcnMucnciXX0.AkC70WSHziqqRoIWYKTwSi_ZqQDI3b5hqhvqZWuW7_PrCmCrqJOjTQID98B9n2REE837YcOgbcl0GKbbZ3JJEQ-_tKF0uIuqIZbuBtn-st-Kqxw4sE7EggqXvbwt5bgu6LTfDOMs2f9Th1Udi_-N3emUjV3IL-9mCZTT-_O4thfhJAG2fNZgg827WpZVBUIUEGcv8JBkF7c7_7JFw1k8ObjlLwCERlHaOpQPUkO3EBl4iWgBz7QVaOC5-I-7qGwDZb77UEmd2AhBILA9HScbKZwGyqD_9PqdqU7zw1P7V4ISYEDEwWnC6i2a4Zc2boa0kEwc37dZhaet6-7GLPVjSsTQ-Xwh3c7CV0DdVBM2qYzqqNdsTvttd8FVHq52XoP7Fty7K2CxWgs2cv_kUFS23dXDwUvwEnSxwiGk7ycpEFnswnsZGNoYgMHTSCmeKBtfvVz_3q3ypSnCT5PbplleQS4RTCjRGZQpsjHGe1aocYYgoSvIwJC47HnD0TjU4N0_HWu9uwitSpd9DgPKLn0oO7ViuqM5DY-ZkETbz7CzxbUyriFjFKDj3UrevvmenZEtBpf1bpOAiU-IOWWFClosbtwCWPhSfSCHASr4ZogRu4ReR04uzAxLNBmlUwQAi4gFRAu-R_JJJmw-nTo7t8OhVIvWwthDKSWRcFsbqSM5RUE" # rubocop:disable Layout/LineLength
  end

  test "is a module" do
    assert_kind_of Module, Zaikio::Procurement
  end

  test "has version number" do
    assert_not_nil ::Zaikio::Procurement::VERSION
  end

  test "it is configurable" do
    Zaikio::Procurement.configure do |config|
      config.environment = :test
    end

    assert_equal :test, Zaikio::Procurement.configuration.environment
  end

  test "fetching suppliers" do
    VCR.use_cassette("suppliers") do
      Zaikio::Procurement.with_token(token) do
        suppliers = Zaikio::Procurement::Supplier.all

        supplier = suppliers.first
        assert_equal "Bounty Soap Inc.", supplier.display_name
      end
    end
  end

  test "fetch a specific supplier" do
    VCR.use_cassette("supplier") do
      Zaikio::Procurement.with_token(token) do
        supplier = Zaikio::Procurement::Supplier.find("a8b99fd3-a790-4366-85b0-2df4af0ca000")
        assert_equal "a8b99fd3-a790-4366-85b0-2df4af0ca000", supplier.id
      end
    end
  end

  test "fetching articles" do
    VCR.use_cassette("articles") do
      Zaikio::Procurement.with_token(token) do
        articles = Zaikio::Procurement::Article.all
        assert articles.any?
      end
    end
  end

  test "fetch a specific article" do
    VCR.use_cassette("article") do
      Zaikio::Procurement.with_token(token) do
        article = Zaikio::Procurement::Article.find("7cbf51bd-35a8-47a1-84a2-57aa63140234")
        assert_equal "7cbf51bd-35a8-47a1-84a2-57aa63140234", article.id
      end
    end
  end

  test "fetch articles by article type or supplier slug" do
    VCR.use_cassette("articles_by_type_or_slug") do
      Zaikio::Procurement.with_token(token) do
        articles = Zaikio::Procurement::Article.list_by_article_type_or_supplier_slug("sappi")
        assert_equal "sappi", Zaikio::Procurement::Supplier.find(articles.first.supplier.id).slug
      end
    end
  end

  test "fetch articles by article type and supplier slug" do
    VCR.use_cassette("articles_by_type_and_slug") do
      Zaikio::Procurement.with_token(token) do
        articles = Zaikio::Procurement::Article.list_by_article_type_and_supplier_slug(
          "substrate", "sappi"
        )

        assert_equal "sappi", Zaikio::Procurement::Supplier.find(articles.first.supplier.id).slug
      end
    end
  end

  test "fetching variants form a specific article" do
    VCR.use_cassette("variants") do
      Zaikio::Procurement.with_token(token) do
        article  = Zaikio::Procurement::Article.find("7cbf51bd-35a8-47a1-84a2-57aa63140234")
        variants = article.variants

        assert variants.any?
        assert_equal article.id, variants.first.article.id
      end
    end
  end

  test "fetching a specific variant" do
    VCR.use_cassette("variant") do
      Zaikio::Procurement.with_token(token) do
        variant = Zaikio::Procurement::Variant.find("845a4d7e-db5a-46a6-9d30-bf2e884cb393")
        assert_equal "845a4d7e-db5a-46a6-9d30-bf2e884cb393", variant.id
      end
    end
  end

  test "fetching skus form a specific variant" do
    VCR.use_cassette("skus") do
      Zaikio::Procurement.with_token(token) do
        variant  = Zaikio::Procurement::Variant.find("845a4d7e-db5a-46a6-9d30-bf2e884cb393")
        skus     = variant.skus

        assert skus.any?
        assert_equal variant.id, skus.first.variant.id
      end
    end
  end

  test "fetching a specific sku" do
    VCR.use_cassette("sku") do
      Zaikio::Procurement.with_token(token) do
        sku = Zaikio::Procurement::Sku.find("08a37cdf-7db7-4c6a-bfdb-4dfc1fb0a7f5")
        assert_equal "08a37cdf-7db7-4c6a-bfdb-4dfc1fb0a7f5", sku.id
      end
    end
  end

  test "fetching prices form a specific sku" do
    VCR.use_cassette("prices") do
      Zaikio::Procurement.with_token(token) do
        sku    = Zaikio::Procurement::Sku.find("08a37cdf-7db7-4c6a-bfdb-4dfc1fb0a7f5")
        prices = sku.prices

        assert prices.any?
        assert_equal sku.id, prices.first.sku.id
      end
    end
  end

  test "fetching a specific price" do
    VCR.use_cassette("price") do
      Zaikio::Procurement.with_token(token) do
        price = Zaikio::Procurement::Price.find("1d996d17-88ef-4b5d-be96-6601061251a4")
        assert_equal "1d996d17-88ef-4b5d-be96-6601061251a4", price.id
      end
    end
  end

  test "search all substrate variants" do
    VCR.use_cassette("search_substrate_variants") do
      Zaikio::Procurement.with_token(token) do
        search = Zaikio::Procurement::SubstrateSearch.new("Magno", grain: "long", paper_weight: 80)

        assert search.results.first.article.name.match?(/Magno/i)
        assert_equal "long", search.results.first.grain
        assert_equal 80, search.results.first.paper_weight

        assert search.facets.present?
      end
    end
  end

  test "search all substrate variants from a specific supplier" do
    VCR.use_cassette("search_substrate_variants_from_supplier") do
      Zaikio::Procurement.with_token(token) do
        search = Zaikio::Procurement::SubstrateSearch.new(
          "Magno", grain: "long", paper_weight: 80, supplier_id: "a8b99fd3-a790-4366-85b0-2df4af0ca000"
        )

        assert search.results.first.article.name.match?(/Magno/i)
        assert_equal "long", search.results.first.grain
        assert_equal 80, search.results.first.paper_weight
        assert_equal "a8b99fd3-a790-4366-85b0-2df4af0ca000", search.results.first.article.supplier.id

        assert search.facets.present?
      end
    end
  end

  test "fetching contracts" do
    VCR.use_cassette("contracts") do
      Zaikio::Procurement.with_token(token) do
        contracts = Zaikio::Procurement::Contract.all
        assert contracts.any?
      end
    end
  end

  test "fetching a specific contract" do
    VCR.use_cassette("contract") do
      Zaikio::Procurement.with_token(token) do
        contract = Zaikio::Procurement::Contract.find("fd677fc7-abd9-460c-b086-34de1a8349e8")
        assert_equal "fd677fc7-abd9-460c-b086-34de1a8349e8", contract.id
      end
    end
  end

  test "fetching contract requests" do
    VCR.use_cassette("contract_requests") do
      Zaikio::Procurement.with_token(token) do
        contract_requests = Zaikio::Procurement::ContractRequest.all
        assert contract_requests.any?
      end
    end
  end

  test "fetching a specific contract request" do
    VCR.use_cassette("contract_request") do
      Zaikio::Procurement.with_token(token) do
        contract_request = Zaikio::Procurement::ContractRequest.find("8fcb6074-63cb-4ea6-aacd-b64a0a75df4a")
        assert_equal "8fcb6074-63cb-4ea6-aacd-b64a0a75df4a", contract_request.id
      end
    end
  end

  test "fetching sales groups" do
    VCR.use_cassette("sales_groups") do
      Zaikio::Procurement.with_token(token) do
        sales_groups = Zaikio::Procurement::SalesGroup.all
        assert sales_groups.any?
      end
    end
  end

  test "fetching a specific sales group" do
    VCR.use_cassette("sales_group") do
      Zaikio::Procurement.with_token(token) do
        sales_group = Zaikio::Procurement::SalesGroup.find("42dcbaf6-e557-4423-96bc-707ebbc223c0")
        assert_equal "42dcbaf6-e557-4423-96bc-707ebbc223c0", sales_group.id
      end
    end
  end

  test "fetching a line item suggestion for a specific variant" do
    VCR.use_cassette("line_item_suggestion") do
      Zaikio::Procurement.with_token(token) do
        variant = Zaikio::Procurement::Variant.find("845a4d7e-db5a-46a6-9d30-bf2e884cb393")
        suggestion = variant.line_item_suggestion(amount: 10, unit: "sheet")
        assert_equal "845a4d7e-db5a-46a6-9d30-bf2e884cb393",
                     suggestion.flat_map { |h| h[:sku].values_at :variant_id }.join
      end
    end
  end
end
