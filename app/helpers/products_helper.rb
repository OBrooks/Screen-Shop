module ProductsHelper
    def brands_for_select
        PhoneBrand.all.collect { |m| [m.brand, m.id] }
    end

    def models_for_select
        PhoneModel.all.collect {|m| [m.model, m.id]}
    end

    def category_name(id)
        if id != nil
            if id != "all"
            Category.find_by(id: id.to_i).category_name
            else
                "Tout"
            end
        else
            "Catégorie"
        end
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

    def phone_model_name(id)
        if id != nil
            if id != "all"
            PhoneModel.find_by(id: id.to_i).model
            else
                "Tout"
            end
        else
            "Modèle"
        end
    end

    def status_name(status)
        if status != nil
            if status != "all"
            I18n.t("status.#{status}")
            else
                "Tout"
            end
        else
            "Statut"
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
