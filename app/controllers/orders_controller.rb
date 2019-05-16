class OrdersController < ApplicationController
    
    def show
        @orders=Order.where(user_id: current_user.id)
    end

    def order
        @order=Order.find(params[:id]) 
        @line_items_orders=LineItemsOrder.where(order_id: @order.id)
    end
end
