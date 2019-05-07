class AddBillingInfoReferencesToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :billing_info, foreign_key: true
  end
end
