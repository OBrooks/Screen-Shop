class AddPhoneNumberToShippingInfos < ActiveRecord::Migration[5.2]
  def change
    add_column :shipping_infos, :phone_number, :integer
  end
end
