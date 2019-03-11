class AdminController < ApplicationController
    def show
    end

    def products_list
        @products=Product.all
    end

    def users_list
        @products = Product.all
    end

    def multiple_update
        params[:product_ids].each do |product|
            puts "ICIIII"
            puts product[0]
            puts product[1[0]][:price]
            puts product[1[0]]
        record = Product.find(product[0])
        record.update(price: product[1[0]][:price], quantity: product[1[0]][:quantity], status: product[1[0]][:status])
            if product[1[0]][:status] != "sales"
                record.update(discount: "0")
            else
                record.update(discount:product[1[0]][:discount])
            end
        end
    redirect_to admin_path
    end

end
