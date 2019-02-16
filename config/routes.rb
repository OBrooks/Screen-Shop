Rails.application.routes.draw do
  
  get 'categories/show'
  root "home#index"
  
  devise_for :users
  
  
  resources :products
    get 'products/all',           to: "products#show"
    get 'product/:id',            to: "products#product"
    patch 'product/:id',          to: "products#quantity_update"


    get 'category/:id',         to: "categories#show"

end
