class MainController < ApplicationController
  # before_action :force_json, only: :search
  def search
    @products = Product.ransack(product_name_cont: params[:q]).result(distinct: true)
    @categories = Category.ransack(category_name_cont: params[:q]).result(distinct: true)
    @phone_models = PhoneModel.ransack(model_cont: params[:q]).result(distinct: true)
    @phone_brands = PhoneBrand.ransack(brand_cont: params[:q]).result(distinct: true)
    respond_to do |format|
      format.html {}
      format.json {
        @products = @products.limit(5)
        @categories = @categories.limit(5)
        @phone_models = @phone_models.limit(5)
        @phone_brands = @phone_brands.limit(5)
      }
    end
  end

  private

  def force_json
    request.format = :json
  end
end
