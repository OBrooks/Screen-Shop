class Delivery < ApplicationRecord
    #ActiveStorage AWS
    has_one_attached :delivery_picture
end
