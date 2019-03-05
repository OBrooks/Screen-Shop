class Category < ApplicationRecord
    has_many :products

    #ActiveStorage AWS
    has_one_attached :category_picture

    #Default picture
    after_commit :add_default_picture, on: [:create, :update]
    private 
    def add_default_picture
        unless category_picture.attached?
            self.category_picture.attach(io: File.open(Rails.root.join("lib", "assets", "images", "phone.jpeg")), filename: 'phone.jpeg' , content_type: "image/jpeg")
        end
    end

end
