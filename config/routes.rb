Rails.application.routes.draw do
  
  get 'categories/show'
  root "home#index"
  
  devise_for :users
  
  resources :brands
    get 'brands/all',             to: "brands#show"
    
  resources :models
    get 'models/all',             to: "models#show"

  resources :categories
    get 'categories/all',         to: "categories#show"
    get 'category/:id',           to: "categories#category"

  resources :products
    get 'products/all',           to: "products#show"
    get 'product/:id',            to: "products#product"
    patch 'product/:id',          to: "products#quantity_update"

  get 'admin',                    to: "admin#show"

  

end
