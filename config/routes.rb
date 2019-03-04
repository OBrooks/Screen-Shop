Rails.application.routes.draw do
  
  get 'categories/show'
  root "home#index"
  
  devise_for :users
  
  resources :brands
    get 'brands/all',           to: "brands#show"

  resources :models

  resources :products
    get 'products/all',           to: "products#show"
    get 'product/:id',            to: "products#product"
    patch 'product/:id',          to: "products#quantity_update"

    get 'category/:id',           to: "categories#show"

    get 'admin',                  to: "admin#show"

end
