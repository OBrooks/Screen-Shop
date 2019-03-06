class AdminController < ApplicationController
    def show
        @products=Product.all
    end

    def quantity_product_update
        @product=Product.find(params[:id])
        @product.update(quantity: params[:product][:quantity])
        redirect_to admin_path
    end
end
