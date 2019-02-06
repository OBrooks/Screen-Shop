class Product < ApplicationRecord
  belongs_to :phone_brand
  belongs_to :phone_model
  belongs_to :category
end
