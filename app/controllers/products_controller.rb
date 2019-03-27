class ProductsController < ApplicationController

    before_action :admin_or_webmaster_access, :only => [:new, :create, :quantity_update, :edit, :update, :destroy]
    before_action :brands_models_all
    
    def new
        @product=Product.new
    end

    def create
        @product=Product.create!(product_name: params[:product][:product_name], 
                                description: params[:product][:description], 
                                quantity: params[:product][:quantity], 
                                price: params[:product][:price], 
                                phone_brand_id: params[:product][:phone_brand_id], 
                                phone_model_id: params[:product][:phone_model_id], 
                                category_id: params[:product][:category_id],
                                product_picture: params[:product][:product_picture])
        redirect_to products_all_path
    end

    def show
        @products=Product.all
        scope_params
        category_params
        brand_params
        model_params
        status_params
        #@products = @products.paginate(page: params[:page], per_page: 5)
    end

    def product
        @product=Product.find(params[:id])
        @line_item=LineItem.new
    end

    def quantity_update
        @product=Product.find(params[:id])
        @product.update(quantity: params[:product][:quantity])
        redirect_to products_all_path
    end

    def edit
        @product=Product.find(params[:id])
    end

    def update
        @product=Product.find(params[:id])
        @product.update(product_name: params[:product][:product_name], 
                                description: params[:product][:description], 
                                quantity: params[:product][:quantity], 
                                price: params[:product][:price], 
                                phone_brand_id: params[:product][:phone_brand_id], 
                                phone_model_id: params[:product][:phone_model_id], 
                                category_id: params[:product][:category_id],
                                status: params[:product][:status])
            if params[:product][:product_picture] != nil 
                @product.update(product_picture: params[:product][:product_picture])
            end
            if params[:product][:status] != "sales"
                @product.update(discount: "0")
            else
                @product.update(discount: params[:product][:discount])
            end
    end

    def destroy
        @product=Product.find(params[:id])
        @product.destroy
        redirect_to products_all_path
    end

    def brands_models_all
        @brands=PhoneBrand.all
    end

    private
    
    def category_params
        if params[:filter_by_category].present?
            if params[:filter_by_category] == "all"
                @products=Product.all
            else
                @products = @products.where(category_id: params[:filter_by_category])
                @brands_ids = Product.where(id: @products.ids).pluck(:phone_brand_id)
                @brands = PhoneBrand.where(id: @brands_ids)
                puts "dans category_params"
                puts @products
            end
        end  
    end

    def scope_params
        if params[:scope] == "recent"
            @products = @products.recent
        elsif params[:scope] == "asc_price"
            @products = @products.asc_price
        elsif params[:scope] == "desc_price"
            @products = @products.desc_price
        # elsif params[:scope– == "name"]
        #     @products=@products.order(product_name: :asc)
        end
    end

    def brand_params
        puts "dans brand params"
        puts @products
        if params[:filter_by_brand].present?
            if params[:filter_by_brand] == "all"
                @products=Product.all
                category_params
            else
                @products = @products.where(phone_brand_id: params[:filter_by_brand])
                @models= PhoneModel.where(phone_brand_id: params[:filter_by_brand])
            end
        end 
    end    

    def model_params
        puts "dans model_params"
        puts @products
        if params[:filter_by_model].present?
            if params[:filter_by_model] == "all"
                brand_params
            else
                @products = @products.where(phone_model_id: params[:filter_by_model])
            end
        end 
    end   

    def status_params
        puts "dans status_params"
        puts @products
        @statuses = Product.statuses
        puts @statuses
        if params[:filter_by_status].present?
            if params[:filter_by_status] == "all"
                brand_params
            else
                @products = @products.where(status: params[:filter_by_status])
            end
        end 
    end   

end
