class AddDeliveryReferencesToCart < ActiveRecord::Migration[5.2]
  def change
    add_reference :carts, :delivery, foreign_key: true
  end
end
