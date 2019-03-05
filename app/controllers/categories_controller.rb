class CategoriesController < ApplicationController
  
  before_action :admin_or_webmaster_access, :only => [:new, :create, :edit, :update, :destroy]

    def new
        @category=Category.new
    end

    def create
        @category=Category.create!(category_name: params[:category][:category_name], category_picture: params[:category][:category_picture])
        redirect_to admin_path
    end

    def edit
        @category=Category.find(params[:id])
    end

    def update
        @category=Category.find(params[:id])
        @category.update(category_name: params[:category][:category_name])
            if params[:category][:category_picture] != nil 
                @category.update(category_picture: params[:category][:category_picture])
            end
        redirect_to categories_all_path
    end

    def destroy
        @category=Category.find(params[:id])
        @category.destroy
        redirect_to categories_all_path
    end
    
    def category
      @category=Category.find(params[:id])
      products=Product.all
      @products_by_category=@category.products
    end

end
