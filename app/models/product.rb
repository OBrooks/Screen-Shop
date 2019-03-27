class Product < ApplicationRecord
  belongs_to :phone_brand
  belongs_to :phone_model
  belongs_to :category
  has_many :line_items

  before_destroy :not_referenced_by_any_line_item

  #Filtering
  scope :recent,      ->{order("created_at DESC")}
  scope :asc_price,   ->{order(:price)}
  scope :desc_price,  ->{order(price: :desc)}

  #ActiveStorage AWS
  has_one_attached :product_picture

  #Status
  enum status: { default: 0, sales: 1, hot: 2}
  STATUSES = Product.statuses.map { |r,| [I18n.t("status.#{r}"), r] }.sort_by { |r| I18n.t("status.#{r}") }

  private
  
  def not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "Line items present")
      throw :abort
    end
  end
end
