Rails.application.routes.draw do
  
  root "home#index"
  
  devise_for :users
  
  
  resource :products
  get 'products/all',           to: "products#show"
  get 'products/:id',           to: "products#product"

end
