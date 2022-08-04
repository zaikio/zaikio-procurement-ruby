require "test_helper"

class Zaikio::ProcurementConsumerTest < ActiveSupport::TestCase
  def token
    "eyJraWQiOiI0ZmZhNTc5MmQwMTJlMjY0YTEzODk5ZmZkYTA3YmVhYzkwOTA4NjRhNmY4MWU5YjQxMGNkOTFkY2UxOTNlODg3IiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJaQUkiLCJzdWIiOiJPcmdhbml6YXRpb24vYjE0NzVmNjUtMjM2Yy01OGI4LTk2ZTEtZTE3NzhiNDNiZWI3IiwiYXVkIjpbImtleWxpbmVfY2xhc3NpYyJdLCJqdGkiOiJkNzQ0MGZhZC1mMzhkLTRlNjEtOWFhZS1lMDMyOTY4MzM2NmQiLCJuYmYiOjE2NTk1MzA3MjksImV4cCI6MTY1OTUzNDMyOSwiamt1IjoiaHR0cHM6Ly9odWIuc2FuZGJveC56YWlraW8uY29tL2FwaS92MS9qd3RfcHVibGljX2tleXMiLCJzY29wZSI6WyJkaXJlY3Rvcnkub3JnYW5pemF0aW9uLnIiLCJkaXJlY3Rvcnkuc2l0ZXMucnciLCJwcm9jdXJlbWVudF9jb25zdW1lci5hcnRpY2xlX2Jhc2UuciIsInByb2N1cmVtZW50X2NvbnN1bWVyLmNhdGFsb2cuciIsInByb2N1cmVtZW50X2NvbnN1bWVyLmNvbnRyYWN0cy5ydyIsInByb2N1cmVtZW50X2NvbnN1bWVyLm1hdGVyaWFsX3JlcXVpcmVtZW50cy5ydyIsInByb2N1cmVtZW50X2NvbnN1bWVyLm9yZGVycy5ydyIsIndhcmVob3VzZS5maW5pc2hlZF9nb29kc19jYWxsX29mZnMuciIsIndhcmVob3VzZS5za3VzLnIiXX0.PJn3bSr9TWfLfEAfOaNCll3zFJOM7uUnbwFRZQF3wcYUv4mctQRDIRLqqNVooAr3T2NeJWDgLotVQ1CyjxkxbNSlyBiy4Vl7CAqYp9jxpz7MvnabYqICclb0Og1hSytR7yTU8gfKec8tAcf7DfvCZd-aob6EyENUEsBqbHyac57W-q3tUSWGFGZAyeXRAR1QUGSSv66OSoXraPqHalfHqpqoC0zcc7Lz4nDAU2UFNBDpxpVBdMvlaDCU4PHcr3yCiYbzXyy1-SMiKW5U2rCWOi1n-s3jX-wLrUr4E6_o6DXHqPVhr_WRfhi80mwWZhgMZjG9qVMiRDkVo1Y1NaRDMg" # rubocop:disable Layout/LineLength
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

  test "fetching upcoming suppliers" do
    VCR.use_cassette("upcoming_suppliers") do
      Zaikio::Procurement.with_token(token) do
        upcoming_suppliers = Zaikio::Procurement::Supplier.upcoming

        upcoming_supplier = upcoming_suppliers.first
        assert_equal "Awesome Upcoming Supplier", upcoming_supplier.name
      end
    end
  end

  test "fetching suppliers" do
    VCR.use_cassette("suppliers") do
      Zaikio::Procurement.with_token(token) do
        suppliers = Zaikio::Procurement::Supplier.all

        supplier = suppliers.first
        assert_equal "Awesome Supplier", supplier.name
      end
    end
  end

  test "fetch a specific supplier" do
    VCR.use_cassette("supplier") do
      Zaikio::Procurement.with_token(token) do
        supplier = Zaikio::Procurement::Supplier.find("b2a0f1ab-7610-451e-acc7-633284300521")
        assert_equal "b2a0f1ab-7610-451e-acc7-633284300521", supplier.id
      end
    end
  end

  test "fetching sites" do
    VCR.use_cassette("sites") do
      Zaikio::Procurement.with_token(token) do
        sites = Zaikio::Procurement::Site.all
        assert sites.any?
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
        order = Zaikio::Procurement::Order.find("1abe8e70-44db-4fb3-beb4-05232bb71016")
        assert_equal "1abe8e70-44db-4fb3-beb4-05232bb71016", order.id
      end
    end
  end

  test "create an order" do
    VCR.use_cassette("create_order") do
      Zaikio::Procurement.with_token(token) do
        order_data = {
          material_requirement_ids: ["9f98e841-1502-4d7b-9b8a-0cf9b8072875"],
          references: ["my order reference"],
          copy_material_requirement_references_to_line_items: true
        }

        assert_difference "Zaikio::Procurement::Order.all.count" do
          Zaikio::Procurement::Order.create(order_data)
        end
      end
    end
  end

  test "place a draft order" do
    VCR.use_cassette("place_order") do
      Zaikio::Procurement.with_token(token) do
        order = Zaikio::Procurement::Order.find("8eaeb37a-d7aa-424a-aac1-1ade4b4030e2")
        order.place

        order.reload
        assert_equal "placed", order.state
      end
    end
  end

  test "deleting a draft order" do
    VCR.use_cassette("delete_order") do
      Zaikio::Procurement.with_token(token) do
        order = Zaikio::Procurement::Order.find("071c2c7c-a182-42c3-8253-a530585d3266")
        order.delete

        assert_raises Zaikio::ResourceNotFound do
          Zaikio::Procurement::Order.find("071c2c7c-a182-42c3-8253-a530585d3266")
        end
      end
    end
  end

  test "cancel a placed order" do
    VCR.use_cassette("cancel_order") do
      Zaikio::Procurement.with_token(token) do
        order = Zaikio::Procurement::Order.find("3d36c6c5-b979-4073-8fcc-78a6cf1bc8bd")
        order.cancel

        order.reload
        assert_equal "canceled_by_consumer", order.state
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

  test "creating a contract request" do
    VCR.use_cassette("create_contract_request") do
      Zaikio::Procurement.with_token(token) do
        assert_difference "Zaikio::Procurement::ContractRequest.all.count" do
          Zaikio::Procurement::ContractRequest.create(
            supplier_id: "061c2b43-ae94-459d-8739-35b20684e47a",
            customer_number: "1968353479",
            contact_first_name: "Frank",
            contact_last_name: "Gallikanokus",
            contact_email: "fgalli@example.com",
            contact_phone: "+3333333333333",
            references: ["my reference"]
          )
        end
      end
    end
  end

  test "fetching material requirements" do
    VCR.use_cassette("material_requirements") do
      Zaikio::Procurement.with_token(token) do
        material_requirements = Zaikio::Procurement::MaterialRequirement.all
        assert material_requirements.any?
      end
    end
  end

  test "fetching a specific material requirement" do
    VCR.use_cassette("material_requirement") do
      Zaikio::Procurement.with_token(token) do
        material_requirement = Zaikio::Procurement::MaterialRequirement.find("92e177a8-76b8-4935-b8f9-666782b9bc57")
        assert_equal "92e177a8-76b8-4935-b8f9-666782b9bc57", material_requirement.id
      end
    end
  end

  test "updating a specific material requirement" do
    VCR.use_cassette("update_material_requirement") do
      Zaikio::Procurement.with_token(token) do
        material_requirement = Zaikio::Procurement::MaterialRequirement.find("dbbeb282-1dca-4cf6-bbd6-0c176190c8b6")
        material_requirement.update(amount: 200)

        assert_equal 200, material_requirement.amount
      end
    end
  end

  test "archive a canceled material requirement" do
    VCR.use_cassette("archive_material_requirement") do
      Zaikio::Procurement.with_token(token) do
        assert_difference "Zaikio::Procurement::MaterialRequirement.all.count", -1 do
          material_requirement = Zaikio::Procurement::MaterialRequirement.find("9c8e55c7-3aa3-4168-9f8a-ef89f8b16acf")
          material_requirement.archive
        end
      end
    end
  end

  test "refresh a material requirement" do
    VCR.use_cassette("refresh_material_requirement") do
      Zaikio::Procurement.with_token(token) do
        material_requirement = Zaikio::Procurement::MaterialRequirement.find("848e864a-d883-4195-9cbb-22f4161969e1")
        material_requirement.refresh

        material_requirement.reload
        assert_equal "in_verification", material_requirement.pricing.accuracy
      end
    end
  end

  test "creating a material requirement" do
    VCR.use_cassette("create_material_requirement") do
      Zaikio::Procurement.with_token(token) do
        material_requirement_data = {
          amount: 200,
          job_client: "Awesome Client",
          job_description: "Awesome print product",
          job_link: "https://www.example.com",
          job_reference: "my job reference",
          material_required_at: "2022-08-03",
          supplier_id: "b2a0f1ab-7610-451e-acc7-633284300521",
          variant_id: "31924842-b38b-47b2-90b0-68f8f42f37d6",
          references: ["my requirement reference"],
          visible_in_web: true
        }

        assert_difference "Zaikio::Procurement::MaterialRequirement.all.count" do
          Zaikio::Procurement::MaterialRequirement.create(material_requirement_data)
        end
      end
    end
  end

  test "deleting a specific material requirement" do
    VCR.use_cassette("delete_material_requirement") do
      Zaikio::Procurement.with_token(token) do
        material_requirement = Zaikio::Procurement::MaterialRequirement.find("92e177a8-76b8-4935-b8f9-666782b9bc57")
        material_requirement.delete

        assert_raises Zaikio::ResourceNotFound do
          Zaikio::Procurement::MaterialRequirement.find("92e177a8-76b8-4935-b8f9-666782b9bc57")
        end
      end
    end
  end

  test "search variants" do
    VCR.use_cassette("search_variants") do
      Zaikio::Procurement.with_token(token) do
        search = Zaikio::Procurement::VariantSearch.new(
          type: "sheet_substrate", query: "Soap",
          grain: "short", paper_weight: 80
        )

        assert search.results.first.article.name.match?(/Soap/i)
        assert search.available_filters.present?
        assert_equal "short", search.results.first.grain
        assert_equal 80, search.results.first.paper_weight
        assert_equal "b1475f65-236c-58b8-96e1-e1778b43beb7", search.results.first.skus.first.suppliers.first.id
      end
    end
  end

  test "fetching a specific variant" do
    VCR.use_cassette("variant") do
      Zaikio::Procurement.with_token(token) do
        variant = Zaikio::Procurement::Variant.find("bbc0a889-4d54-481e-a3dd-0ad7a52d0243")
        assert_equal "bbc0a889-4d54-481e-a3dd-0ad7a52d0243", variant.id
      end
    end
  end

  test "fetching skus form a specific variant" do
    VCR.use_cassette("skus") do
      Zaikio::Procurement.with_token(token) do
        variant = Zaikio::Procurement::Variant.find("bbc0a889-4d54-481e-a3dd-0ad7a52d0243")
        skus = variant.skus

        assert skus.any?
      end
    end
  end
end
