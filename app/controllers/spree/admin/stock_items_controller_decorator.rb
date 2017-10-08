Spree::Admin::StockItemsController.class_eval do
  after_action :add_variant_to_supplier, only: :create

  private

  def add_variant_to_supplier
    variant = Spree::Variant.find(params[:variant_id])
    stock_location = Spree::StockLocation.find(params[:stock_location_id])
    stock_supplier = stock_location.supplier

    if stock_supplier && !stock_supplier.in?(variant.suppliers)
      variant.suppliers << stock_supplier
    end
  end
end
