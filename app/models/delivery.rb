class Delivery < ApplicationRecord

    has_many :carts

    #ActiveStorage AWS
    has_one_attached :delivery_picture


    #Default picture
    after_commit :add_default_picture, on: [:create, :update]
    private 
    def add_default_picture
        unless delivery_picture.attached?
            self.delivery_picture.attach(io: File.open(Rails.root.join("lib", "assets", "images", "delivery-default.png")), filename: 'delivery-default.png' , content_type: "image/png")
        end
    end

    def name_and_price
        "#{name} - #{ActionController::Base.helpers.number_to_currency(price)}"
    end

    #for image {ActionController::Base.helpers.image_tag(delivery_picture)} 
end
