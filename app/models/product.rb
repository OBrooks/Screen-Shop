class Product < ApplicationRecord
  belongs_to :phone_brand
  belongs_to :phone_model
  belongs_to :category

  #ActiveStorage AWS
  has_one_attached :product_picture

  #Status
  enum status: { default: 0, new_product: 1, sale: 2, hot: 3}
end
