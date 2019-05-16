class BillingInfo < ApplicationRecord
    belongs_to :user
    has_many :adress_for_carts
    has_many :carts, through: :adress_for_carts
    has_many :orders
end
