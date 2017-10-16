Spree::Stock::Coordinator.class_eval do

  def stock_locations_with_requested_variants
    stock_items = Spree::StockItem.where(variant_id: requested_variant_ids).
      where('spree_stock_items.count_on_hand > 0').
      joins('inner join spree_supplier_variants on spree_stock_items.variant_id = spree_supplier_variants.variant_id and spree_supplier_variants.cost > 0')

    Spree::StockLocation.where(id: stock_items.select(:stock_location_id))
  end

end
