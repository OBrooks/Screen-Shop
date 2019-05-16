class Order < ApplicationRecord

    has_many :line_items_orders,    dependent: :destroy
    belongs_to :delivery,           optional: true
    belongs_to :user
    belongs_to :shipping_info
    belongs_to :billing_info

        #Status
    enum status: { paid: 0, refunded: 1, partially_refunded: 2}
end
