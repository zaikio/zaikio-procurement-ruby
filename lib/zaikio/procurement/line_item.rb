module Zaikio
  module Procurement
    class LineItem < Base
      # Attributes
      attributes :sku_id, :amount, :unit, :palletized, :order_number
    end
  end
end
