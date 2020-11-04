require "test_helper"

class Zaikio::ProcurementTest < ActiveSupport::TestCase
  def setup
    Zaikio::Procurement.configure do |config|
      config.environment = :test
    end
  end

  def token
    "eyJraWQiOiIwYTlhNmZkMjRlMjIyZmU5NjgwMTNkOWQyOWY2N2U0ZGJlYTE2NzIzNTk3NzY3M2FiNDZhZmYxNjE2NjI3NzliIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJaQUkiLCJzdWIiOiJPcmdhbml6YXRpb24vNWU0ODM4M2QtYjI3Ni00ZDcwLWI2OTAtOWUyMDMyZTNjZDNhIiwiYXVkIjpbImtleWxpbmVfY2xhc3NpYyJdLCJqdGkiOiIzYThkNWY5ZS1jMTRiLTRlNDgtOTQ2ZS05MTRiMDdkNDEzN2UiLCJuYmYiOjE2MDQ0ODc3MTQsImV4cCI6MTYwNDQ5MTMxNCwiamt1IjoiaHR0cHM6Ly9odWIuc2FuZGJveC56YWlraW8uY29tL2FwaS92MS9qd3RfcHVibGljX2tleXMiLCJzY29wZSI6WyJwcm9jdXJlbWVudF9jb25zdW1lci5jYXRhbG9nLnIiXX0.TaY772slD2w2nkc9kBhpspyLWe1M8g94vzpNlsCYR9GJAmVV6kIXmia4-4qg91FaBzwO5VkZ8w4Ot7hne5ly9_OChhAz-KJHag8J_gXrUG4lum_wWloUfRnISRJDfpji0Y3EqnP19mEgmsyaOToS1NW0nqbv5zKBbhF62NpAhavacx5Anxjp2LdIS2wf28JSO4oOC1NTnRg9ieg1QakSh4uy6032iCoVwXICy1KBnR-3pQtvaobM7pCpanBsoAaideDl6N0ueEILnvQGkrXx5eSUZ21J8KKiXnasYuPwd9ZYt-1ox3CbAry7vBQOhbuIGX1gp-zSedJRGgwSAIV-ahszZ8TWet3FX7O7hamfVp-7pKj45Quc15UwslYEOyGSn4ACKahr-ru-2F1K7mn6ork9-T93TR3morYIfNSYRQO4EbRbs2PMeJxKvoKdIYjRIXSJEV2dxxRwY75LrKsf223BqzALisBzQy8iaGH0O-zAfaxDEF6a9XNe3vewwAUYiGX_QKaSnc2cSBYe9KDAewiMPPQ3uhKzfwvKk4IHymwFAnYzryi-kqPUGru7_oHF1k7mdsOe-fsoPnP3lIEXtBL0LcfgTebe0X-i99vISY4403y36OTOMIkD430WvkIAi8juorH4JHDnVlvv_qw3bnPNrdLcqPpm7CGjL4zBcBY" # rubocop:disable Layout/LineLength
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
        articles = Zaikio::Procurement::Article.list_by_article_type_or_supplier_slug("paper_mill")
        assert_equal "paper_mill", Zaikio::Procurement::Supplier.find(articles.first.supplier.id).slug
      end
    end
  end

  test "fetch articles by article type and supplier slug" do
    VCR.use_cassette("articles_by_type_and_slug") do
      Zaikio::Procurement.with_token(token) do
        articles = Zaikio::Procurement::Article.list_by_article_type_and_supplier_slug(
          "substrate", "paper_mill"
        )

        assert_equal "paper_mill", Zaikio::Procurement::Supplier.find(articles.first.supplier.id).slug
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
        price = Zaikio::Procurement::Price.find("4a54b5c2-111d-4b6d-a7a3-007812fafabd")
        assert_equal "4a54b5c2-111d-4b6d-a7a3-007812fafabd", price.id
      end
    end
  end

  test "search variants from a specific supplier" do
    VCR.use_cassette("search_variants_from_supplier") do
      Zaikio::Procurement.with_token(token) do
        supplier = Zaikio::Procurement::Supplier.find("a8b99fd3-a790-4366-85b0-2df4af0ca000")
        variants = supplier.search("Magno", grain: "long")

        assert variants.first.article.name.match?(/Magno/i)
        assert_equal "long", variants.first.grain
        assert_equal "a8b99fd3-a790-4366-85b0-2df4af0ca000", variants.first.article.supplier.id
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
        contract_request = Zaikio::Procurement::ContractRequest.find("82e673de-4d78-4959-979b-ed4f799f53b7")
        assert_equal "82e673de-4d78-4959-979b-ed4f799f53b7", contract_request.id
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
        sales_group = Zaikio::Procurement::SalesGroup.find("2688312d-bca6-4851-8cc8-310bad084eb6")
        assert_equal "2688312d-bca6-4851-8cc8-310bad084eb6", sales_group.id
      end
    end
  end
end
