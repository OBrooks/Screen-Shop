class PhoneModel < ApplicationRecord
  belongs_to :phone_brand
  has_many :products
  
  #ActiveStorage AWS
  has_one_attached :model_picture
end
