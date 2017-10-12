class Spree::Admin::SupplierVariantsController < Spree::Admin::ResourceController

  def update
    @variant.class.transaction do
      @variant.cost = params[:cost]
      @variant.save!

      @variant.set_best_price_from_suppliers!
    end

    head :ok
  end

  protected

  def find_resource
    @variant = Spree::SupplierVariant.find(params[:id])
  end

end
