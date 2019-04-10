class AdressForCart < ApplicationRecord
  belongs_to :cart
  belongs_to :shipping_info
end
