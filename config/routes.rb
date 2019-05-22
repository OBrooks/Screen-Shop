Rails.application.routes.draw do

  root "home#index"
  
  devise_for :users, controllers: { confirmations: 'confirmations' }
  
  #Orders
    get   'myorders',                           to: "orders#show"
    get   'order-detail/:id',                   to: "orders#order",                         as: "order_detail"

  resources :brands
    get   'brands/all',                         to: "brands#show"
    
  resources :models
    get   'models/all',                         to: "models#show"

  resources :deliveries
    get   'deliveries/all',                     to: "deliveries#show"

  resources :categories
    get   'categories/all',                     to: "categories#show"
    # get 'categories/show'

  resources :products,  :except => [:index]
    get   'products',                           to: "products#show",                          as: :filtered_products
    get   'product/:id',                        to: "products#product"
    patch 'product/:id',                        to: "products#quantity_update"

    get   'admin',                              to: "admin#show"
    get   'admin/products_list',                to: "admin#products_list"
    patch 'admin/products_list',                to: "admin#product_multi_update"
    get   'admin/users_list',                   to: "admin#users_list"
  
  resources :admin do
    collection do
      patch 'multiple_update'
    end
  end
    get 'new_discount_code',                    to: "admin#new_discount_code"
    post 'create_discount_code',                to: "admin#create_discount_code"
    get 'discount_codes',                       to: "admin#show_discount_code"
    get 'edit_code/:id',                        to: "admin#edit_discount_code",                 as: "edit_code"
    patch 'update_code/:id',                    to: "admin#update_discount_code"
    delete 'delete_code',                       to: "admin#delete_discount_code"

  resources :line_items
  resources :carts
    patch 'cart/delivery_update',               to: "carts#update_delivery" 
    get   'resume',                             to: "carts#resume"
    get   'login_cart',                         to: "carts#login"
    get   'edit_shipping_adress',               to: "carts#different_shipping_adress"
    patch 'cart/shipping_infos',                to: "carts#update_shipping_infos"
    get   'cart/select_adress',                 to: "carts#select_shipping_adress"
    get   'display_form_edit_shipping_address', to: "carts#display_form_edit_shipping_address"
    post  'payment',                            to: "carts#resume_payment"
    post  'cart/discount_code',                 to: "carts#apply_coupon"

  #Shipping Adress & Info
    delete 'shipping_info/delete',              to: "shipping_info#destroy"
    get   'shipping_info/add_adress',           to: "shipping_info#add_shipping_adress"
  
  #Billing Adress & Info
    get    'billing_adress',                    to: "billing_infos#different_billing_adress"
    post  'billing_infos',                      to: "billing_infos#create"
    delete 'billing_info/delete',               to: "billing_infos#destroy"

  end
