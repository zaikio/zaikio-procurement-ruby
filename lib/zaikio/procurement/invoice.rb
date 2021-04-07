module Zaikio
  module Procurement
    class Invoice < Base
      uri "invoices(/:id)"
      include_root_in_json :invoice
    end
  end
end
