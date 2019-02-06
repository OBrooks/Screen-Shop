class Product < ApplicationRecord
  belongs_to :phone_brand
  belongs_to :phone_model
  belongs_to :category

  #ActiveStorage AWS
  has_one_attached :product_picture
end
