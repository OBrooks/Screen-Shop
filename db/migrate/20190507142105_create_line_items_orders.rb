class CreateLineItemsOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items_orders do |t|
      t.references :product, foreign_key: true
      t.references :order, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
