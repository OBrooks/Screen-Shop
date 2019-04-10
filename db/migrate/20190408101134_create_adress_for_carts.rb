class CreateAdressForCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :adress_for_carts do |t|
      t.references :cart, foreign_key: true
      t.references :shipping_info, foreign_key: true

      t.timestamps
    end
  end
end
