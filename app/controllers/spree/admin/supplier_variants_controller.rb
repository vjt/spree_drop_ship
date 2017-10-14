class Spree::Admin::SupplierVariantsController < Spree::Admin::ResourceController

  def update
    @variant.cost = params[:cost]
    @variant.save!

    head :ok
  end

  protected

  def find_resource
    @variant = Spree::SupplierVariant.find(params[:id])
  end

end
