class AdminController < ApplicationController
    def show
        @products=Product.all
    end
end
