class ShippingInfoController < ApplicationController

    def destroy
        @shipping_info = ShippingInfo.find(params[:id])
        @adress_for_cart = AdressForCart.find_by(shipping_info_id: @shipping_info.id)
        @adress_for_cart.destroy
        @shipping_info.destroy
        respond_to do |format|
            format.html { redirect_to root_path }
            format.js { render inline: "location.reload();" }
        end
    end

    def add_shipping_adress
        puts "Les params du add shipping sont #{params}"
        puts "Le current est #{current_user.id}"
        @user = current_user
        @shipping_info = ShippingInfo.create!(user_id: @user.id, street_number: 0)
        @adress_for_cart = AdressForCart.create!(cart_id: params[:cart_id], shipping_info_id: @shipping_info.id)
        respond_to do |format|
            format.html { redirect_to @cart}
            format.js { }
        end
    end
end
