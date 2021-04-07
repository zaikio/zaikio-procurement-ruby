require "test_helper"

class Zaikio::ProcurementConsumerTest < ActiveSupport::TestCase
  def token
    "eyJraWQiOiIwYTlhNmZkMjRlMjIyZmU5NjgwMTNkOWQyOWY2N2U0ZGJlYTE2NzIzNTk3NzY3M2FiNDZhZmYxNjE2NjI3NzliIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJaQUkiLCJzdWIiOiJPcmdhbml6YXRpb24vNWU0ODM4M2QtYjI3Ni00ZDcwLWI2OTAtOWUyMDMyZTNjZDNhIiwiYXVkIjpbImtleWxpbmVfY2xhc3NpYyJdLCJqdGkiOiIwOWRkMjFmMy05OTJlLTQ1ZjEtYjE4Ni1kZDEwZmE1NjI1N2IiLCJuYmYiOjE2MTE2NTU2OTQsImV4cCI6MTYxMTY1OTI5NCwiamt1IjoiaHR0cHM6Ly9odWIuc2FuZGJveC56YWlraW8uY29tL2FwaS92MS9qd3RfcHVibGljX2tleXMiLCJzY29wZSI6WyJkaXJlY3Rvcnkub3JnYW5pemF0aW9uLnIiLCJwcm9jdXJlbWVudF9jb25zdW1lci5jYXRhbG9nLnIiLCJwcm9jdXJlbWVudF9jb25zdW1lci5jb250cmFjdHMucnciLCJwcm9jdXJlbWVudF9jb25zdW1lci5vcmRlcnMucnciXX0.pXlb8-BgI5OK3JGfH6zrFcCTWTnZloWwrpdhBHbzODn9ejdbJ9fLgUpFrA1K0K7C8xu-6T8XkQr_9Lm2_QbH2eXC9gSsOt-PGQqO_-naVfLhbVwJt23gXn-7jK-UTpOw_Qtq1SEJXsEM2V2M_UYrqdC1JocPZ_LQ5Cu0ce1HWjtBpNeTFnqvfDGSE_VxYPStzDJagIlwoDA_rkH0qO_E5Gs-_-3zYE2f_EwFQX-xHErrobmgtjm8Mgt1Gq_c6GacAmg4NWcWfs67Ee5ocrXMPtcN7-E6VacdKonE0vpmllBwHJ3dH0AwgA0FzNt06EkGDkI_7UwoAPBZrH-ijuOz_vKyHIhAfe6xgBKdk-yEOU86WecaQ8HpFeOLsw8LDVBKoZem1uN1uKvsObhI2ROnHfwva4hQ_cUi4pXRxn3aaPsTUPVCfHnVLdSvoENkYncYYj7C6-B5LWFtFo9h-s-sF1dLiK9ahvKGhrf4gAPvKZ0w_HnKu9joeKzk-6XgJanS4Gqk__MZF8uzuTmZDqzXI7lnNxkTmoFBoR9bl1gaknf8VNNJmFv4vChixc9UX-SbkkUiBB7xZEdsXo-SxIXrnOYznAv8eSMG6mcy3ARppiBnfckvD6QOGyaKCud5nsd31hMdvH2z0OhKXEx61AoS9dQpaAgN3lnQ7mpfVeYPtdI" # rubocop:disable Layout/LineLength
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

  test "fetching a line item suggestions for multiple variant from a specifi supplier" do
    VCR.use_cassette("supplier_line_item_suggestions") do
      Zaikio::Procurement.with_token(token) do
        supplier = Zaikio::Procurement::Supplier.find("a8b99fd3-a790-4366-85b0-2df4af0ca000")
        suggestion = supplier.line_item_suggestions(
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
        )

        assert_includes suggestion[:line_item_suggestions].flat_map { |h| h[:variant_id] },
                        "0001b94e-4e87-4ee9-8b14-6ff9910b4f26"
      end
    end
  end

  test "fetching orders" do
    VCR.use_cassette("orders") do
      Zaikio::Procurement.with_token(token) do
        orders = Zaikio::Procurement::Order.all
        assert orders.any?
      end
    end
  end

  test "fetching a specific order" do
    VCR.use_cassette("order") do
      Zaikio::Procurement.with_token(token) do
        order = Zaikio::Procurement::Order.find("a29f3c77-5e53-4658-a741-afd1824f4829")
        assert_equal "a29f3c77-5e53-4658-a741-afd1824f4829", order.id
      end
    end
  end

  test "create an order" do
    VCR.use_cassette("create_order") do
      Zaikio::Procurement.with_token(token) do
        order_data = {
          contract_id: "fd677fc7-abd9-460c-b086-34de1a8349e8",
          delivery_mode: "complete",
          exclusive_sales_group_id: "42dcbaf6-e557-4423-96bc-707ebbc223c0",
          references: ["CO/XXXXXX"],
          state_event: "place",
          deliveries_attributes: [
            {
              address_addressee: "Joey’s Print Ltd",
              address_text: "Emmerich-Josef-Straße 1A, 55116 Mainz",
              desired_delivery_date: 2.days.from_now,
              references: ["D/XXXXXX"]
            }
          ],
          order_line_items_attributes: [
            {
              sku_id: "26b3aadc-928f-4d1a-ba2d-13ac3c8f523d",
              amount: 108_000
            }
          ]
        }

        assert_difference "Zaikio::Procurement::Order.all.count" do
          Zaikio::Procurement::Order.create(order_data)
        end
      end
    end
  end

  test "fetching order line items for a specific order" do
    VCR.use_cassette("order_line_items") do
      Zaikio::Procurement.with_token(token) do
        order = Zaikio::Procurement::Order.find("a29f3c77-5e53-4658-a741-afd1824f4829")
        assert order.order_line_items.any?
      end
    end
  end

  test "fetching a specific order line item" do
    VCR.use_cassette("order_line_item") do
      Zaikio::Procurement.with_token(token) do
        order_line_item = Zaikio::Procurement::OrderLineItem.find("42e5b736-a015-4b9f-a8e0-218e98e2c15f")
        assert_equal "42e5b736-a015-4b9f-a8e0-218e98e2c15f", order_line_item.id
      end
    end
  end

  test "add order line item to an exisiting draft order" do
    VCR.use_cassette("add_order_line_item") do
      Zaikio::Procurement.with_token(token) do
        order = Zaikio::Procurement::Order.find("86b4a0c5-6d54-4702-a059-da258643f260")
        assert_difference "order.order_line_items.count" do
          order.order_line_items.create(sku_id: "6535eeb0-45c2-4c63-8cb9-4814562bb875", amount: 68_000)
        end
      end
    end
  end

  test "update a specific order line item" do
    VCR.use_cassette("update_order_line_item") do
      Zaikio::Procurement.with_token(token) do
        order_line_item = Zaikio::Procurement::OrderLineItem.find("058a5513-925e-4d0c-923d-fa1ed4bfb3ce")
        order_line_item.update(amount: 69_000)
        assert_equal 69_000, order_line_item.amount
      end
    end
  end

  test "delete a specific order line item" do
    VCR.use_cassette("delete_order_line_item") do
      Zaikio::Procurement.with_token(token) do
        order_line_item = Zaikio::Procurement::OrderLineItem.find("2f5a99c2-9734-4aac-9cee-911b061d3a5a")
        assert_difference "order_line_item.order.order_line_items.count", -1 do
          order_line_item.delete
        end
      end
    end
  end

  test "fetching deliveries for a specific order" do
    VCR.use_cassette("deliveries") do
      Zaikio::Procurement.with_token(token) do
        order = Zaikio::Procurement::Order.find("a29f3c77-5e53-4658-a741-afd1824f4829")
        assert order.deliveries.any?
      end
    end
  end

  test "fetching a specific delivery" do
    VCR.use_cassette("delivery") do
      Zaikio::Procurement.with_token(token) do
        delivery = Zaikio::Procurement::Delivery.find("46a67d80-ff21-403a-9cb3-5b3a9464ae0f")
        assert_equal "46a67d80-ff21-403a-9cb3-5b3a9464ae0f", delivery.id
      end
    end
  end

  test "fetching delivery line items for a specific delivery" do
    VCR.use_cassette("delivery_line_items") do
      Zaikio::Procurement.with_token(token) do
        delivery = Zaikio::Procurement::Delivery.find("46a67d80-ff21-403a-9cb3-5b3a9464ae0f")
        assert delivery.delivery_line_items.any?
      end
    end
  end

  test "fetching a specific delivery line item" do
    VCR.use_cassette("delivery_line_item") do
      Zaikio::Procurement.with_token(token) do
        delivery_line_item = Zaikio::Procurement::DeliveryLineItem.find("75bcb56f-63c2-4ff3-9374-2d0f9c29f0e0")
        assert_equal "75bcb56f-63c2-4ff3-9374-2d0f9c29f0e0", delivery_line_item.id
      end
    end
  end
end
