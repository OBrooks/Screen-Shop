class ProductsController < ApplicationController

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
        redirect_to root_path
    end

    def show
        @products=Product.all
    end

    def try
        @products=Product.all
    end
end
