class AddQuantityAndPriceAndDiscountToLineItemsOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items_orders, :price, :decimal, :precision => 8, :scale => 2 
    add_column :line_items_orders, :discount, :integer, default: 0
  end
end
