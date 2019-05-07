class RemoveStatusFromLineItemsOrder < ActiveRecord::Migration[5.2]
  def change
    remove_column :line_items_orders, :status, :integer
  end
end
