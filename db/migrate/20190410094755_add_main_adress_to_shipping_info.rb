class AddMainAdressToShippingInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :shipping_infos, :main_adress, :boolean
  end
end
