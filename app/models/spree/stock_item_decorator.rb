Spree::StockItem.class_eval do

  def supplier_variant
    supplier_id = self.stock_location.supplier_id
    return unless supplier_id

    self.variant.supplier_variants.where(supplier_id: supplier_id).first!
  end

end
