class PhoneBrand < ApplicationRecord
    has_many :phone_models
    has_many :products
end
