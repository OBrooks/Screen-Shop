module MailerHelper
        
    def info_is_nil(info)
        if info != nil
            info
        end
    end

    def attachement_or_picture(product)
        if product.product_picture.attachment != nil
            image_tag(product.product_picture)
        end
    end
end