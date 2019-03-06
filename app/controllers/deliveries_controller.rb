class DeliveriesController < ApplicationController

    before_action :admin_or_webmaster_access
    
    def new
        @delivery=Delivery.new
    end

    def create
        @delivery=Delivery.create!(name: params[:delivery][:name], price: params[:delivery][:price], delivery_picture: params[:delivery][:delivery_picture])
        redirect_to deliveries_all_path
    end

    def show
        @deliveries=Delivery.all
    end

    def edit
        @delivery=Delivery.find(params[:id])
    end

    def update
        @delivery=Delivery.find(params[:id])
        @delivery.update(name: params[:delivery][:name], price: params[:delivery][:price])
            if params[:delivery][:delivery_picture] != nil 
                @delivery.update(delivery_picture: params[:delivery][:delivery_picture])
            end
        redirect_to deliveries_all_path
    end

    def destroy
        @delivery=Delivery.find(params[:id])
        @delivery.destroy
        redirect_to deliveries_all_path
    end

end
