class AdminController < ApplicationController

    after_action :set_cart

    def show
    end

    def products_list
        @products=Product.all
    end

    def users_list
        @users = User.all.customer
    end

    def multiple_update
        params[:product_ids].each do |product|
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

    #################
    # Discount Codes
    #################
    def new_discount_code
        @discount_code=DiscountCode.new
    end

    def create_discount_code
        @discount_code = DiscountCode.create!(  code: params[:discount_code][:code],
                                                discount: params[:discount_code][:discount],
                                                "start_date(3i)": params[:discount_code][:"start_date(3i)"],
                                                "start_date(2i)": params[:discount_code][:"start_date(2i)"],
                                                "start_date(1i)": params[:discount_code][:"start_date(1i)"],
                                                "start_date(4i)": params[:discount_code][:"start_date(4i)"],
                                                "start_date(5i)": params[:discount_code][:"start_date(5i)"],
                                                "end_date(3i)": params[:discount_code][:"end_date(3i)"],
                                                "end_date(2i)": params[:discount_code][:"end_date(2i)"],
                                                "end_date(1i)": params[:discount_code][:"end_date(1i)"],
                                                "end_date(4i)": params[:discount_code][:"end_date(4i)"],
                                                "end_date(5i)": params[:discount_code][:"end_date(5i)"])
        redirect_to admin_path
    end

    def show_discount_code
        @discount_codes = DiscountCode.all
    end

    def edit_discount_code
        @discount_code = DiscountCode.find(params[:id])
    end

    def update_discount_code
        @discount_code = DiscountCode.find(params[:id])
        puts "#{@discount_code}"
        @discount_code.update!(code: params[:discount_code][:code],
                                discount: params[:discount_code][:discount],
                                                "start_date(3i)": params[:discount_code][:"start_date(3i)"],
                                                "start_date(2i)": params[:discount_code][:"start_date(2i)"],
                                                "start_date(1i)": params[:discount_code][:"start_date(1i)"],
                                                "start_date(4i)": params[:discount_code][:"start_date(4i)"],
                                                "start_date(5i)": params[:discount_code][:"start_date(5i)"],
                                                "end_date(3i)": params[:discount_code][:"end_date(3i)"],
                                                "end_date(2i)": params[:discount_code][:"end_date(2i)"],
                                                "end_date(1i)": params[:discount_code][:"end_date(1i)"],
                                                "end_date(4i)": params[:discount_code][:"end_date(4i)"],
                                                "end_date(5i)": params[:discount_code][:"end_date(5i)"])
        puts "#{@discount_code.code}"
        redirect_to admin_path
    end

    def delete_discount_code
        puts "Les params sont #{params}"
        @discount_code = DiscountCode.find(params[:id])
        @discount_code.destroy
    end

end
