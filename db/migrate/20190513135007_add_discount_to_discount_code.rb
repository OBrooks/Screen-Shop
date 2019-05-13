class AddDiscountToDiscountCode < ActiveRecord::Migration[5.2]
  def change
    add_column :discount_codes, :discount, :integer
  end
end
