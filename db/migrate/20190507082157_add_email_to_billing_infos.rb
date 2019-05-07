class AddEmailToBillingInfos < ActiveRecord::Migration[5.2]
  def change
    add_column :billing_infos, :email, :string
  end
end
