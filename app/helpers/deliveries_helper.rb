module DeliveriesHelper

    def delivery_time_expressed(x)
        if x < 3
            y = x * 24
            x = "#{y}h"
        else 
            x = "#{x} jours"
        end
    end


    def delivery_time(delivery_time)
        preparation_time = 1
        current_time = Time.now
        time = Time.now.advance(days: delivery_time + preparation_time)
        if Time.now.hour > 14
            time = time.advance(days: 1)
        end
        delivery_time = I18n.localize(time, format: :normal)
    end


    def set_time_zone
        if logged_in?
        Time.use_zone(current_user.time_zone) { yield }
        else
        yield
        end
    end
end
