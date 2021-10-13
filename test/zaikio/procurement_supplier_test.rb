require "test_helper"

class Zaikio::ProcurementSupplierTest < ActiveSupport::TestCase
  def token
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJaQUkiLCJpYXQiOjE2MjEyNDkzODcsImV4cCI6MTY1Mjc4NTM4NywiYXVkIjoia2V5bGluZV9jbGFzc2ljIiwic3ViIjoiT3JnYW5pemF0aW9uL2JjY2IzY2NhLTcyZmItNDllNy04ZWFjLTllMDFhOGFmZjJkZSJ9.lIcRlY2NCZFIpIGkQsJxNhYI_9FC2WAq4-O7aCR5BT0" # rubocop:disable Layout/LineLength
  end

  def valid_token
    "eyJraWQiOiJhNmE1MzFjMGZhZTVlNWE1MDAzZDI2ZTRhMTIwMmIwNjg2ZDFkNTRjNGZhYTViZDlkZTBjMzdkY2JkY2RkYzdlIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJaQUkiLCJzdWIiOiJPcmdhbml6YXRpb24vYmNjYjNjY2EtNzJmYi00OWU3LThlYWMtOWUwMWE4YWZmMmRlIiwiYXVkIjpbImtleWxpbmVfY2xhc3NpYyJdLCJqdGkiOiI0MThjZGJkYy03M2ViLTQzZDEtOGQzZi05YmI5ZTMxODE3MmIiLCJuYmYiOjE2MzQxMjkyODUsImV4cCI6MjI2NTI4MTI4NSwiamt1IjoiaHR0cHM6Ly9odWIuemFpa2lvLnRlc3QvYXBpL3YxL2p3dF9wdWJsaWNfa2V5cyIsInNjb3BlIjpbInByb2N1cmVtZW50X3N1cHBsaWVyLmNhdGFsb2cucnciLCJwcm9jdXJlbWVudF9zdXBwbGllci5jb250cmFjdHMucnciLCJwcm9jdXJlbWVudF9zdXBwbGllci5vcmRlcnMucnciXX0.BBDwzCjdJ7J78f8zzjKiCOXQXpSdAOn5NmLc6Qtq0L-hR_K1Ei5ru5mPzwwX9WJIX_mmBZomMySJxe8t_7gYrjTidJsYaJVAMSuhzBtXLlXDQ-GddNUwMx62rxcMv0TpbYDS8ZH-WA0vTE3zqi7BQs4vif7-ejBTjKQL_wWIshZW9wLa4zzT0TDyMiAJG6wsuv0wv3ZoOPzIKVLR4POF0fpxYtXF6VhBkxsl5Jf4dmBFmSmuZuVNu86df4cSvwfmE-01HWPYjme1W8rz8aw9JOB74RUnM2z6eT-9ku_Sd--DI8iZHxNqeaKWWJqh2YIGLcmHncrWhJyTaXqGutasfg" # rubocop:disable Layout/LineLength
  end

  test "fetching articles" do
    VCR.use_cassette("supplier_articles") do
      Zaikio::Procurement.with_token(token) do
        articles = Zaikio::Procurement::Article.all
        assert articles.any?
      end
    end
  end

  test "fetching articles with pagination" do
    VCR.use_cassette("supplier_articles_multiple_pages") do
      Zaikio::Procurement.with_token(token) do
        articles = Zaikio::Procurement::Article.all.per_page(1).to_a
        assert_equal 3, articles.size
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

  test "fetching sales group memberships" do
    VCR.use_cassette("supplier_sales_group_memberships") do
      Zaikio::Procurement.with_token(token) do
        sales_group_memberships = Zaikio::Procurement::SalesGroupMembership.all
        assert sales_group_memberships.any?
      end
    end
  end

  test "fetching and updating availability checks" do
    VCR.use_cassette("supplier_material_availabilitc_checks") do
      Zaikio::Procurement.with_token(valid_token) do
        availability_check = Zaikio::Procurement::MaterialAvailabilityCheck
                             .find("40009396-d4e8-48eb-801e-c43f868748e1")
        assert_equal 500, availability_check.amount
        assert_equal "pallet", availability_check.unit
        assert_nil availability_check.responded_at

        availability_check.update(
          earliest_delivery_date: 20.days.from_now,
          stock_availability_amount: 1_000,
          confirmed_price: "89000.40",
          expires_at: 1.hour.from_now
        )

        availability_check = Zaikio::Procurement::MaterialAvailabilityCheck
                             .find("40009396-d4e8-48eb-801e-c43f868748e1")
        assert_equal 1_000, availability_check.stock_availability_amount
        assert_not_nil availability_check.responded_at
      end
    end
  end
end
