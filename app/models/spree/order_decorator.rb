Spree::Order.class_eval do

  has_many :stock_locations, through: :shipments
  has_many :suppliers, through: :stock_locations

  register_update_hook :send_supplier_email

  private

  # Once order is finalized we want to notify the suppliers of their drop ship
  # orders. Here we are handling notification by emailing the suppliers.
  #
  def send_supplier_email
    return unless  SpreeDropShip::Config[:send_supplier_email]

    shipments.each do |shipment|
      next unless shipment.supplier.present?

      Spree::DropShipOrderMailer.supplier_order(shipment.id).deliver_later!
    end
  end

end
