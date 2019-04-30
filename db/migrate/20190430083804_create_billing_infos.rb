class CreateBillingInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :billing_infos do |t|
      t.references :user, foreign_key: true
      t.string :civility
      t.string :first_name,         null: false, default: ""
      t.string :last_name,          null: false, default: ""

      t.integer :street_number
      t.string  :street_name,       null: false, default: ""
      t.string  :street_name2 

      t.string  :zip_code,          null: false, default: ""
      t.string  :city,              null: false, default: ""
      t.integer :phone_number
      t.timestamps
    end
  end
end
