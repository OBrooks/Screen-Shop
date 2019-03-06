module DeliveriesHelper

    def delivery_time_expressed(x)
        if x < 3
            y = x * 24
            x = "#{y}h"
        else 
            x = "#{x} jours"
        end
    end
end
