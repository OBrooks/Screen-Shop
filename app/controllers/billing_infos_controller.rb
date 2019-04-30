class BillingInfosController < ApplicationController

    def different_billing_adress
        respond_to do |format|
            format.html { redirect_to @cart}
            format.js { }
        end
        @cart = Cart.find(params[:cart_id])
        @billing_info=BillingInfo.new
    end

    def create
        @billing_info=BillingInfo.create!(  civility: params[:billing_info][:civility],
                                first_name: params[:billing_info][:first_name],
                                last_name: params[:billing_info][:last_name],
                                street_number: params[:billing_info][:street_number],
                                street_name: params[:billing_info][:street_name], 
                                street_name2: params[:billing_info][:street_name2], 
                                zip_code: params[:billing_info][:zip_code], 
                                city: params[:billing_info][:city],
                                phone_number: params[:billing_info][:phone_number],
                                user_id: current_user.id)
        @adress_for_cart = AdressForCart.find_by(cart_id: params[:billing_info][:cart_id])
        if @adress_for_cart == nil
            @adress_for_cart = AdressForCart.create!(cart_id: params[:cart_id], billing_info_id: @billing_info.id)
        else
            @adress_for_cart.update(billing_info_id: @billing_info.id)
        end
        respond_to do |format|
            format.html { redirect_to resume_path }
            format.js { render inline: "location.reload();" }
        end
    end

    def destroy
        @billing_info = BillingInfo.find(params[:id])
        @adress_for_cart = AdressForCart.find_by(billing_info_id: @billing_info.id)
        @adress_for_cart.destroy
        @billing_info.destroy
        respond_to do |format|
            format.html { redirect_to root_path }
            format.js { render inline: "location.reload();" }
        end
    end

end
