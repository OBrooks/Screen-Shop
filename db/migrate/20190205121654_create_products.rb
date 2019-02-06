class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :product_name
      t.string :description
      t.decimal :price, :precision => 8, :scale => 2 
      t.belongs_to :phone_brand, index: true
      t.belongs_to :phone_model, index: true
      t.belongs_to :category, index: true

      t.timestamps
    end
  end
end
