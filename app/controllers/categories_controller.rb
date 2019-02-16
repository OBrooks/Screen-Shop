class CategoriesController < ApplicationController
  
    def show
      @category=Category.find(params[:id])
      products=Product.all
      @products_by_category=@category.products
    end

end
