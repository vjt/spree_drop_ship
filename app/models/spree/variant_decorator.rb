module Spree
  Variant.class_eval do

    has_many :supplier_variants
    has_many :suppliers, through: :supplier_variants

    before_create :populate_for_suppliers

    def supplier_price(supplier)
      supplier_variant = self.supplier_variants.where(supplier_id: supplier).first
      return unless supplier_variant

      price = default_price.dup
      price.amount = supplier_variant.cost
      return price
    end

    def best_supplier
      self.suppliers.order("#{SupplierVariant.table_name}.cost").first
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
