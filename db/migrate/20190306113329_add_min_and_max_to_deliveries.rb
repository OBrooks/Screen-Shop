class AddMinAndMaxToDeliveries < ActiveRecord::Migration[5.2]
  def change
    add_column :deliveries, :delivery_time, :integer
  end
end
