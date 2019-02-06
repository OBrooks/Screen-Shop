class PhoneModel < ApplicationRecord
  belongs_to :phone_brand
  has_many :products
end
