class ApplicationController < ActionController::Base

    include CurrentCart

    before_action :sanitize_devise_params, if: :devise_controller?
    before_action :show_categories
    before_action :set_cart

    def sanitize_devise_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :birthdate, :street_number, :street_name, :street_name2, :zip_code, :city, :status, :gender])
        devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :birthdate, :street_number, :street_name, :street_name2, :zip_code, :city, :status, :gender])
    end   

    def admin_or_webmaster
        if current_user != nil
            current_user.admin? == true || current_user.webmaster? == true
        else
            redirect_to root_path
        end
    end

    def admin_or_webmaster_access
        if admin_or_webmaster == false
            redirect_to root_path 
        end
    end

    def show_categories
        @categories=Category.all
    end
end
