module Zaikio
  module Procurement
    class Availability < Base
      # Attributes
      attributes :delivery_date, :in_stock, :accuracy, :verified_at
    end
  end
end
