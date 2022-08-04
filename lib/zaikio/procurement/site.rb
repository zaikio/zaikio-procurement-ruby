module Zaikio
  module Procurement
    class Site < Base
      uri "sites(/:id)"

      # Associations
      has_one :address, class_name: "Zaikio::Procurement::Address",
                        uri: nil
    end
  end
end
