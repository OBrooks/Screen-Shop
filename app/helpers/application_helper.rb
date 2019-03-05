module ApplicationHelper
    def admin_or_webmaster
        current_user.admin? == true || current_user.webmaster? == true
    end
end
