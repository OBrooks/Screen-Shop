
puts "In Stripe baby"
Rails.configuration.stripe = {
  :publishable_key => Rails.application.credentials.dig(:stripe, :publishable_key),
  :secret_key      => Rails.application.credentials.dig(:stripe, :secret_key)
}

puts "In Stripe"
puts Rails.application.credentials.dig(:stripe, :secret_key)


Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)