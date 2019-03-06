class ProductsController < ApplicationController

    before_action :admin_or_webmaster_access, :only => [:new, :create, :quantity_update, :edit, :update, :destroy]

    def new
        @product=Product.new
    end

    def create
        @product=Product.create!(product_name: params[:product][:product_name], 
                                description: params[:product][:description], 
                                quantity: params[:product][:quantity], 
                                price: params[:product][:price], 
                                phone_brand_id: params[:product][:phone_brand_id], 
                                phone_model_id: params[:product][:phone_model_id], 
                                category_id: params[:product][:category_id],
                                product_picture: params[:product][:product_picture])
        redirect_to products_all_path
    end

    def show
        @products=Product.all
    end

    def product
        @product=Product.find(params[:id])
    end

    def quantity_update
        @product=Product.find(params[:id])
        @product.update(quantity: params[:product][:quantity])
        redirect_to products_all_path
    end

    def edit
        @product=Product.find(params[:id])
    end

    def update
        @product=Product.find(params[:id])
        @product.update(product_name: params[:product][:product_name], 
                                description: params[:product][:description], 
                                quantity: params[:product][:quantity], 
                                price: params[:product][:price], 
                                phone_brand_id: params[:product][:phone_brand_id], 
                                phone_model_id: params[:product][:phone_model_id], 
                                category_id: params[:product][:category_id],
                                status: params[:product][:status])
            if params[:product][:product_picture] != nil 
                @product.update(product_picture: params[:product][:product_picture])
            end
            if params[:product][:discount] != nil 
                @product.update(discount: params[:product][:discount])
            end
    end

    def destroy
        @product=Product.find(params[:id])
        @product.destroy
        redirect_to products_all_path
    end

end
