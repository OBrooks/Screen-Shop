class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  belongs_to :user

  def total_price
    product.price.to_d * quantity.to_i
  end
  
end
