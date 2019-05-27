json.products do
    json.array!(@products) do |product|
        json.name product.product_name
        json.url product_single_view_path(product)
    end
end

json.categories do
    json.array!(@categories) do |category|
        json.name category.category_name
        json.url filtered_products_path(filter_by_category: category)
    end
end

json.phone_models do
    json.array!(@phone_models) do |model|
        json.name model.model
        json.url filtered_products_path(filter_by_model: model)
    end
end

json.phone_brands do
    json.array!(@phone_brands) do |brand|
        json.name brand.brand
        json.url filtered_products_path(filter_by_brand: brand)
    end
end