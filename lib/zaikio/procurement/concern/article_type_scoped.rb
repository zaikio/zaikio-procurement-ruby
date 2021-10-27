module Zaikio
  module Procurement
    module ArticleTypeScoped
      extend ActiveSupport::Concern
      included do
        scope :substrate, -> { where(type: :substrate) }
        scope :plate, -> { where(type: :plate) }
      end
      module ClassMethods
        def find(id)
          if Zaikio::Procurement.configuration.flavor == :supplier &&
             (current_scope.nil? || current_scope.params[:type].blank?)
            raise ArgumentError, "id and type are required for #{name.demodulize} in Supplier API"
          end

          super
        end
      end
    end
  end
end
