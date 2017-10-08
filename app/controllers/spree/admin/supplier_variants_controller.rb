class Spree::Admin::SupplierVariantsController < Spree::Admin::ResourceController

  def update
    @object.cost = params[:cost]
    @object.save!

    head :ok
  end

  protected

  def find_resource
    Spree::SupplierVariant.find(params[:id])
  end

end
