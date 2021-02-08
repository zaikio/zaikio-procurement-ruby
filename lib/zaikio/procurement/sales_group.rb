module Zaikio
  module Procurement
    class SalesGroup < Base
      uri "sales_groups(/:id)"

      # Attributes
      attributes :currency, :exclusive, :name, :created_at, :updated_at
    end
  end
end
