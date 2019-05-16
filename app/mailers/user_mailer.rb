class UserMailer < ApplicationMailer
    helper MailerHelper
    include MailerHelper

    def order_summary(order)
        @order = order
        puts "L'order 1 est #{order.id}"
        @user = User.find(order.user_id)
        puts "Le user est #{@user.email}"
        puts "Le order est #{@order.id}"
        @line_items_orders = LineItemsOrder.where(order_id: @order.id)
        puts "Coucou les lines #{@line_items_orders.ids}"
        mail(to: @user.email, subject: "ScreenShop - Votre commande N°#{@order.id}")
        puts "Fin de order_summary"
    end
end
