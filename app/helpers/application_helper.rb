module ApplicationHelper
    def admin_or_webmaster
        if current_user != nil
            current_user.admin? == true || current_user.webmaster? == true
        end
    end

    def cart_count
        if @cart.line_items.count > 0
            return "<span>( #{@cart.line_items.count} )</span>".html_safe
        end
    end

    def cart_count_over_one
        @cart.line_items.count >0
    end

end
