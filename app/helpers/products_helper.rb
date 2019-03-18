module ProductsHelper
    def brands_for_select
        PhoneBrand.all.collect { |m| [m.brand, m.id] }
    end

    def models_for_select
        PhoneModel.all.collect {|m| [m.model, m.id]}
    end

    def phone_brand_name(id)
        if id != nil
            if id != "all"
            PhoneBrand.find_by(id: id.to_i).brand
            else
                "Tout"
            end
        else
            "Marque"
        end
    end

    def filter_by_display(scope)
        if scope != nil
            if scope == "recent"
                "Date de sortie"
            elsif scope == "asc_price"
                "Prix croissant"
            else
                "Prix décroissant"
            end
        else
            "Filtrer par"
        end
    end

end
