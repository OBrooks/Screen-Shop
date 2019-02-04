class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
  validates_presence_of :nickname, uniqueness: true, on: :create
  validates_presence_of :birthdate, on: :create
  validates_presence_of :gender, on: :create
  validates_presence_of :town, on: :create
  validates_presence_of :first_name, on: :create
  validates_presence_of :last_name, on: :create
end
