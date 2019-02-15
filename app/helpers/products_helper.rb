module ProductsHelper
    def brands_for_select
        PhoneBrand.all.collect { |m| [m.brand, m.id] }
    end

    def models_for_select
        PhoneModel.all.collect {|m| [m.model, m.id]}
    end


end
