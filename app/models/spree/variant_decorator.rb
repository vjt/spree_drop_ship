module Spree
  Variant.class_eval do

    has_many :supplier_variants
    has_many :suppliers, through: :supplier_variants

    before_create :populate_for_suppliers

    # Returns the price practiced by the given supplier
    #
    def supplier_price(supplier)
      return unless (supplier_variant = self.supplier_variant(supplier))

      price = default_price.dup
      price.amount = supplier_variant.cost
      return price
    end

    # Returns the count on hand of the given supplier
    #
    def supplier_count_on_hand(supplier)
      return unless (supplier_variant = self.supplier_variant(supplier))

      supplier_variant.count_on_hand
    end

    # Returns the supplier variant record for the given supplier, or nil
    # if not found.
    #
    def supplier_variant(supplier)
      self.supplier_variants.where(supplier_id: supplier).first
    end

    # Returns the supplier with the lowest price
    #
    def best_supplier
      self.suppliers.order("#{SupplierVariant.table_name}.cost").first
    end

    # Sets the product price from the suppliers' lowest price
    #
    def set_price_from_suppliers_best_price!
      price = self.default_price
      price.amount = best_supplier_price || 0.0
      price.save!
    end

    # Get the lowest supplier price, considering only available stock items
    #
    def best_supplier_price
      self.supplier_variants.joins(:supplier => {:stock_locations => :stock_items}).
        where('spree_stock_items.variant_id = spree_supplier_variants.variant_id').
        where('spree_stock_items.count_on_hand > 0').
        minimum(:cost)
    end

    private

    durably_decorate :create_stock_items, mode: 'strict', sha: '98704433ac5c66ba46e02699f3cf03d13d4f1281' do
      StockLocation.where(propagate_all_variants: true).each do |stock_location|
        if stock_location.supplier_id.blank? || self.suppliers.pluck(:id).include?(stock_location.supplier_id)
          stock_location.propagate_variant(self)
        end
      end
    end

    def populate_for_suppliers
      self.suppliers = self.product.suppliers
    end

  end
end
