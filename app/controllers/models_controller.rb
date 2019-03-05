class ModelsController < ApplicationController

    before_action :admin_or_webmaster_access, :only => [:new, :create, :edit, :update, :destroy]

    def new
        @model=PhoneModel.new
    end

    def create
        @model=PhoneModel.create!(phone_brand_id: params[:phone_model][:phone_brand_id],model: params[:phone_model][:model], model_picture: params[:phone_model][:model_picture])
        redirect_to admin_path
    end

    def show
        @models=PhoneModel.all
    end

    def edit
        @model=PhoneModel.find(params[:id])
    end

    def update
        @model=PhoneModel.find(params[:id])
        @model.update(model: params[:phone_model][:model], phone_brand_id: params[:phone_model][:phone_brand_id])
            if params[:phone_model][:model_picture] != nil 
                @model.update(model_picture: params[:phone_model][:model_picture])
            end
        redirect_to models_all_path
    end

    def destroy
        @model=PhoneModel.find(params[:id])
        @model.destroy
        redirect_to models_all_path
    end


end
