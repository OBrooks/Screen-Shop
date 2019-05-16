# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
    
    def order_summary
        UserMailer.with(order: Order.last).order_summary(order: Order.last)
    end
end
