require "test_helper"

class Zaikio::ProcurementSupplierTest < ActiveSupport::TestCase
  def token
    "eyJraWQiOiIwYTlhNmZkMjRlMjIyZmU5NjgwMTNkOWQyOWY2N2U0ZGJlYTE2NzIzNTk3NzY3M2FiNDZhZmYxNjE2NjI3NzliIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJaQUkiLCJzdWIiOiJPcmdhbml6YXRpb24vMzc3OTQ2MmYtOTdiMC00MmFkLWE2MTgtZThmNjhjNWY3NTQyIiwiYXVkIjpbIk9yZ2FuaXphdGlvbi8zNzc5NDYyZi05N2IwLTQyYWQtYTYxOC1lOGY2OGM1Zjc1NDIiXSwianRpIjoiODNlNWY3OGQtYmNmMS00MTM4LTlhYTktZDgxNjM4M2ZiYTAwIiwibmJmIjoxNjE3NzE2NDg3LCJleHAiOjE2NDkyNTI0ODYsImprdSI6Imh0dHBzOi8vaHViLnNhbmRib3guemFpa2lvLmNvbS9hcGkvdjEvand0X3B1YmxpY19rZXlzIiwic2NvcGUiOlsicHJvY3VyZW1lbnRfc3VwcGxpZXIuY2F0YWxvZy5ydyIsInByb2N1cmVtZW50X3N1cHBsaWVyLmNvbnRyYWN0cy5ydyIsInByb2N1cmVtZW50X3N1cHBsaWVyLm9yZGVycy5ydyJdfQ.iGGNv-LbxesOlbzeDxDIDYUKUKg7n-AwoKcEB33GVwhnX0Ch6q9k7lfSt5a0TnarEdb6LehHZ1bpbjZ-1dVD6A8RLj8WZO8u7HBSREJWT4roiXFiJHLlYkJvBBNkxH31khdTaLrfwI9BenNis1kzkHh2fA1cKubBdzPoVkF937o-3krNXXMftlFWKXVUwNZLMPqo39MExdBWpux5quE9CxHnsYI8vIu6QpddrEBiQnYzezXOPgjdx-Cp9B3l0XVNLgy0-xUGtMSB3b5h7BPHvM-YF4UZgBn2Yj194oCDwRxyVSRVkxmSXtWSE5owwYTotRj2_2bQzBtzOZyXRCWUOu0z_tn1OjL3D10pNkI4YcmoAYmh5uEl1kU7oB2xJNOsrAMf9pjWwjg-oJsbHT4jqmlZKf2F4I8YjgL55yV5kYuKogB1MwhjsCOad9RH36XNmfV_ixQNxYtfEeucXhfVu456yvtZzHeyLUAas2tghTn69piWmn-GtQ9AkqelG-azbf1ZpN0Hyl1EMvM-Q6KEnbX5lB4v_Mc32-vCUGFZRdYLJsL184bCuPYyaviNDA89o6AITlq40n96HUNXjhvl5Zc2yjUQfI3eI-dqHtZTqyejPXFhUDRVhemee-sIfz8Qz8nHfKKplxMX1PNZtHA7Mbx6BFcRQtCthurDL2I1nOM" # rubocop:disable Layout/LineLength
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
