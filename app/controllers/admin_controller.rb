class AdminController < ApplicationController
    def show
    end

    def products_list
        @products=Product.all
    end

    def users_list
        @users= User.all
    end
    
    def product_multi_update
        @product=Product.find(params[:id])
        @product.update(quantity: params[:product][:quantity], price: params[:product][:price], status: params[:product][:status])
        if params[:product][:status] != "sales"
            @product.update(discount: "0")
        else
            @product.update(discount: params[:product][:discount])
        end
        
        redirect_to admin_products_list_path
    end

end
