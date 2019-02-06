class CreatePhoneModels < ActiveRecord::Migration[5.2]
  def change
    create_table :phone_models do |t|
      t.string :model
      t.references :phone_brand, index: true

      t.timestamps
    end
  end
end
