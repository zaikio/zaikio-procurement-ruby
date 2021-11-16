module Zaikio
  module Procurement
    class Address < Base
      attributes :addition,
                 :addressable,
                 :addressee,
                 :country_code,
                 :county,
                 :kind,
                 :location,
                 :number,
                 :state,
                 :street,
                 :text,
                 :town,
                 :types,
                 :zip_code,
                 :created_at,
                 :updated_at
    end
  end
end
