class AddStatusToLineItemsOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items_orders, :status, :integer, default: 0
  end
end
