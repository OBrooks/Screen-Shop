class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :carts
  has_many :line_items, through: :cart
  has_many :shipping_infos

  validates_presence_of :first_name, on: :create

  #Status
  enum status: { customer: 0, admin: 1, webmaster: 2}
  enum gender: { male: 0, female: 1, not_sure: 2, prefer_not_to_disclose: 3 }

end
