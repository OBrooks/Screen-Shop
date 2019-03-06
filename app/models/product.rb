class Product < ApplicationRecord
  belongs_to :phone_brand
  belongs_to :phone_model
  belongs_to :category

  #ActiveStorage AWS
  has_one_attached :product_picture

  #Status
  enum status: { default: 0, sales: 1, hot: 2}
  STATUSES = Product.statuses.map { |r,| [I18n.t("status.#{r}"), r] }.sort_by { |r| I18n.t("status.#{r}") }
end
