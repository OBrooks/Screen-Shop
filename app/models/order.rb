class Order < ApplicationRecord

    has_many :line_items_orders,    dependent: :destroy
    belongs_to :delivery,           optional: true
    belongs_to :user
    has_many :shipping_infos

        #Status
    enum status: { paid: 0, refunded: 1, partially_refunded: 2}
end
