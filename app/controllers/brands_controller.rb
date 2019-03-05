class BrandsController < ApplicationController
     before_action :admin_or_webmaster_access, :only => [:new, :create, :edit, :update, :destroy]

    def new
        @brand=PhoneBrand.new
    end

    def create
        @brand=PhoneBrand.create!(brand: params[:phone_brand][:brand], brand_picture: params[:phone_brand][:brand_picture])
        redirect_to admin_path
    end

    def show
        @brands=PhoneBrand.all
    end

    def edit
        @brand=PhoneBrand.find(params[:id])
    end

    def update
        @brand=PhoneBrand.find(params[:id])
        @brand.update(brand: params[:phone_brand][:brand])
            if params[:phone_brand][:brand_picture] != nil 
                @brand.update(brand_picture: params[:phone_brand][:brand_picture])
            end
        redirect_to brands_all_path
    end

    def destroy
        @brand=PhoneBrand.find(params[:id])
        @brand.destroy
        redirect_to brands_all_path
    end

end
