class Cart < ApplicationRecord

    has_many :line_items, dependent: :destroy
    belongs_to :delivery, optional: true
    belongs_to :user
    has_many :adress_for_carts
    has_many :shipping_infos, through: :adress_for_carts

    #Status
    enum status: { unpaid: 0, paid: 1, refunded: 2, partially_refunded: 3}

    def add_product(product)
        current_item = line_items.find_by(product_id: product.id)
        if current_item
            current_item.increment(:quantity)
        else
            current_item = line_items.build(product_id: product.id)
        end
        current_item
    end

    def sub_total_price
        line_items.to_a.sum { |item| item.total_price}
    end

    def total_price
        if delivery != nil
            sub_total_price + delivery.price
        end
    end   

end
