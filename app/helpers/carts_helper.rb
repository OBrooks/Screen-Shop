module CartsHelper
    def missing_shipping_info(user)
        if user.shipping_infos == nil
            render 'carts/form'    
        else
            render 'carts/shipping_infos'
        end
    end

    def check_if_checked(adress_for_cart, shipping_info, cart)
            if adress_for_cart != nil && adress_for_cart.shipping_info_id == shipping_info && adress_for_cart.cart_id == cart
                render "check_boxes/check_shipping_adress_true"
            else
                render "check_boxes/check_shipping_adress_false"
            end
    end

    def attachement_or_picture_delivery(delivery)
        if delivery.delivery_picture.attachment != nil
            image_tag(delivery.delivery_picture)
        
        end
    end

end
