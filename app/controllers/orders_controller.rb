class OrdersController < ApplicationController
    
    def show
        @orders=Order.where(user_id: current_user.id)
    end
end
