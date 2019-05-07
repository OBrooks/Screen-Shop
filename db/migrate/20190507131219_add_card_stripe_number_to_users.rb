class AddCardStripeNumberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :card_stripe_number, :string
  end
end
