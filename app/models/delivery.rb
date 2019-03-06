class Delivery < ApplicationRecord
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
end
