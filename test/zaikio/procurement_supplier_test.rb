require "test_helper"

class Zaikio::ProcurementSupplierTest < ActiveSupport::TestCase
  def token
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJaQUkiLCJpYXQiOjE2MjEyNDkzODcsImV4cCI6MTY1Mjc4NTM4NywiYXVkIjoia2V5bGluZV9jbGFzc2ljIiwic3ViIjoiT3JnYW5pemF0aW9uL2JjY2IzY2NhLTcyZmItNDllNy04ZWFjLTllMDFhOGFmZjJkZSJ9.lIcRlY2NCZFIpIGkQsJxNhYI_9FC2WAq4-O7aCR5BT0" # rubocop:disable Layout/LineLength
  end

  test "fetching articles" do
    VCR.use_cassette("supplier_articles") do
      Zaikio::Procurement.with_token(token) do
        articles = Zaikio::Procurement::Article.all
        assert articles.any?
      end
    end
  end

  test "fetching a specific article" do
    VCR.use_cassette("supplier_article") do
      Zaikio::Procurement.with_token(token) do
        article = Zaikio::Procurement::Article.find("ee8de074-bedf-403d-b1f0-d4edc2a675a9")
        assert_equal "ee8de074-bedf-403d-b1f0-d4edc2a675a9", article.id
      end
    end
  end

  test "create an article" do
    VCR.use_cassette("create_supplier_article") do
      Zaikio::Procurement.with_token(token) do
        article_data = {
          base_unit: "piece",
          coated: "none",
          description: "A high volume matt paper with a pleasant feel and non-reflective surface.",
          external_identifier: "A/XXXXXX",
          finish: "\"matte\", \"painted\", \"glossy\", \"elephant skin\"",
          kind: "paper",
          name: "Magno Matt",
          variants_attributes: [
            {
              brightness: 0,
              category: "PS1 - Premium Coated",
              dimensions_unit: "mm",
              external_identifier: "V/XXXXXX",
              color: "\"white\", \"light grey\"",
              form: "envelope",
              grain: "long",
              height: 700,
              paper_weight: 150,
              paper_weight_unit: "gsm",
              roughness: 0,
              transparency: 0,
              thickness: 150,
              unit_system: "metric",
              whiteness: 0,
              width: 1000,
              skus_attributes: [
                {
                  amount: 1,
                  amount_in_base_unit: 1000,
                  availability_in_days: 2,
                  dimension_unit: "mm",
                  environmental_certification: "FSC 30%",
                  external_identifier: "S/XXXXXX",
                  gross_weight: 100,
                  height: 100,
                  length: 100,
                  net_weight: 90,
                  order_number: "O/XXXXXX",
                  unit: "kg",
                  weight_unit: "g",
                  width: 100
                }
              ]
            }
          ]
        }

        assert_difference "Zaikio::Procurement::Article.all.count" do
          Zaikio::Procurement::Article.create(article_data)
        end
      end
    end
  end

  test "fetching the variants of an article" do
    VCR.use_cassette("supplier_article_variants") do
      Zaikio::Procurement.with_token(token) do
        article = Zaikio::Procurement::Article.find("ee8de074-bedf-403d-b1f0-d4edc2a675a9")
        variants = article.variants

        assert variants.any?
        assert_equal article.id, variants.first.article.id
      end
    end
  end

  test "create a price for a specific sku" do
    VCR.use_cassette("create_supplier_sku_price") do
      Zaikio::Procurement.with_token(token) do
        price_data = {
          external_identifier: "string",
          kind: "static",
          minimum_order_quantity: 10,
          order_number: "P/XXXXXX",
          price: "102.4",
          sales_group_id: "a12d217b-9e5d-4faf-a070-bc9a7fe2a82c",
          valid_from: "2021-04-07T17:39:31.174Z",
          valid_until: "2021-04-07T17:39:31.174Z"
        }

        sku = Zaikio::Procurement::Sku.find("3db5c502-766b-43d3-a0ec-0b87161e816b")

        assert_difference "sku.prices.count" do
          sku.prices.create(price_data)
        end
      end
    end
  end
end
