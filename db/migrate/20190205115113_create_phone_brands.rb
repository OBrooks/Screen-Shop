class CreatePhoneBrands < ActiveRecord::Migration[5.2]
  def change
    create_table :phone_brands do |t|
      t.string :brand

      t.timestamps
    end
  end
end
