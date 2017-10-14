module Spree
  class SupplierVariant < Spree::Base
    belongs_to :supplier
    belongs_to :variant

    after_save :set_best_price_from_suppliers!

    private

    # Gets the supplier with the best price and updates the related product's
    # price with it.
    def set_best_price_from_suppliers!
      price = self.variant.default_price
      price.amount = best_supplier_price
      price.save!
    end

    def best_supplier_price
      self.variant.supplier_variants.minimum(:cost)
    end
  end
end
