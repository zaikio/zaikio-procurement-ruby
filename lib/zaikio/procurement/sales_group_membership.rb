module Zaikio
  module Procurement
    class SalesGroupMembership < Base
      uri "sales_group_memberships(/:id)"
      include_root_in_json :sales_group_membership

      # Attributes
      attributes :contract, :sales_group, :created_at, :updated_at
    end
  end
end
