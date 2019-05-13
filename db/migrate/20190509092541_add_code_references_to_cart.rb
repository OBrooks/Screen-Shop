class AddCodeReferencesToCart < ActiveRecord::Migration[5.2]
  def change
    add_reference :carts, :discount_code, foreign_key: true
  end
end
