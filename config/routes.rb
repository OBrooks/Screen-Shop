Rails.application.routes.draw do

  root "home#index"
  
  devise_for :users
  
  resources :brands
    get   'brands/all',             to: "brands#show"
    
  resources :models
    get   'models/all',             to: "models#show"

  resources :deliveries
    get   'deliveries/all',         to: "deliveries#show"

  resources :categories
    get   'categories/all',         to: "categories#show"
    # get 'categories/show'

  resources :products,  :except => [:index]
    get   'products',               to: "products#show",              as: :filtered_products
    get   'product/:id',            to: "products#product"
    patch 'product/:id',            to: "products#quantity_update"

    get   'admin',                  to: "admin#show"
    get   'admin/products_list',    to: "admin#products_list"
    patch 'admin/products_list',    to: "admin#product_multi_update"
    get   'admin/users_list',       to: "admin#users_list"
  
  resources :admin do
    collection do
      patch 'multiple_update'
    end
  end

  resources :line_items
  resources :carts
    patch 'cart/delivery_update',     to: "carts#update_delivery" 
end
