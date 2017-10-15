module Spree
  class SupplierVariant < Spree::Base
    belongs_to :supplier
    belongs_to :variant

    after_save    :set_variant_price_from_suppliers_best_price!
    after_destroy :set_variant_price_from_suppliers_best_price!

    def stock_items
      self.variant.stock_items.where(stock_location: self.supplier.stock_locations)
    end

    def count_on_hand
      stock_items.sum(:count_on_hand)
    end

    private

    def set_variant_price_from_suppliers_best_price!
      self.variant.set_price_from_suppliers_best_price!
    end

  end
end
