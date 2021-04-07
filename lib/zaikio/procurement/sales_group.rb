module Zaikio
  module Procurement
    class SalesGroup < Base
      uri "sales_groups(/:id)"
      include_root_in_json :sales_group

      # Attributes
      attributes :currency, :exclusive, :name, :created_at, :updated_at
    end
  end
end
