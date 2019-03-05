class PhoneModel < ApplicationRecord
  belongs_to :phone_brand
  has_many :products
  
  #ActiveStorage AWS
  has_one_attached :model_picture

  #Default picture
  after_commit :add_default_picture, on: [:create, :update]
  
  private 
  def add_default_picture
    unless model_picture.attached?
      self.model_picture.attach(io: File.open(Rails.root.join("lib", "assets", "images", "default-model.jpg")), filename: 'default-model.jpg' , content_type: "image/jpg")
    end
  end
end
