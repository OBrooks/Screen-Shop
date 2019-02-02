class ApplicationController < ActionController::Base

    before_action :sanitize_devise_params, if: :devise_controller?

    def sanitize_devise_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :birthdate, :street_number, :street_name, :street_name2, :zip_code, :city, :status, :gender])
        devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :birthdate, :street_number, :street_name, :street_name2, :zip_code, :city, :status, :gender])
    end   

end
