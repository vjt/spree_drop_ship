Spree::StockItem.class_eval do

  after_save    :set_variant_price_from_suppliers_best_price!
  after_destroy :set_variant_price_from_suppliers_best_price!

  def supplier_variant
    supplier_id = self.stock_location.supplier_id
    return unless supplier_id

    self.variant.supplier_variants.where(supplier_id: supplier_id).first
  end

  private

  def set_variant_price_from_suppliers_best_price!
    self.variant.set_price_from_suppliers_best_price!
  end

end
