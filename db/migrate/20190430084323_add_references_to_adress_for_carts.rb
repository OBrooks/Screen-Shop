class AddReferencesToAdressForCarts < ActiveRecord::Migration[5.2]
  def change
    add_reference :adress_for_carts, :billing_info, foreign_key: true
  end
end
