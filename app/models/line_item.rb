class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  belongs_to :user,                 optional: true

  def total_price
    product.price = product.price * (1 - ((product.discount.to_d)/100))
    product.price.to_d * quantity.to_i
  end
  
end
