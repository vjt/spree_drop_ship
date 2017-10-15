module Spree
  class SupplierVariant < Spree::Base
    belongs_to :supplier
    belongs_to :variant

    after_save    :set_variant_price_from_suppliers_best_price!
    after_destroy :set_variant_price_from_suppliers_best_price!

    private

    def set_variant_price_from_suppliers_best_price!
      self.variant.set_price_from_suppliers_best_price!
    end

  end
end
