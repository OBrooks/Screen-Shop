class PhoneBrand < ApplicationRecord
    has_many :phone_models
    has_many :products
    
    #ActiveStorage AWS
    has_one_attached :brand_picture

    #Default picture
    after_commit :add_default_picture, on: [:create, :update]
    private 
    def add_default_picture
        unless brand_picture.attached?
            self.brand_picture.attach(io: File.open(Rails.root.join("lib", "assets", "images", "default-brand.png")), filename: 'default-brand.png' , content_type: "image/png")
        end
    end
end
