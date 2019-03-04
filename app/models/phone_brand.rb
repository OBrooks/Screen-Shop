class PhoneBrand < ApplicationRecord
    has_many :phone_models
    has_many :products
    
    #ActiveStorage AWS
    has_one_attached :brand_picture
end
