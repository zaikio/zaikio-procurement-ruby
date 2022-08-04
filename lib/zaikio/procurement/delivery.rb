module Zaikio
  module Procurement
    class Delivery < Base
      # Associations
      has_one :site,     class_name: "Zaikio::Procurement::Site",
                         uri: nil
      has_one :address,  class_name: "Zaikio::Procurement::Address",
                         uri: nil
    end
  end
end
