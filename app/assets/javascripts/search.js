document.addEventListener("turbolinks:load", function () {
    $input = $("[data-behavior='autocomplete']")
    var options = {
        getValue: "name",
        url: function (phrase) {
            return "/search.json?q=" + phrase;
        },
        categories: [{
                listLocation: "products",
                header: "<strong>Products</strong>",
            },
            {
                listLocation: "categories",
                header: "<strong>Catégories</strong>",
            },
            {
                listLocation: "phone_models",
                header: "<strong>Modèles</strong>",
            },
            {
                listLocation: "phone_brands",
                header: "<strong>Marques</strong>",
            }
        ],
        list: {
            onChooseEvent: function () {
                var url = $input.getSelectedItemData().url
                $input.val("")
                Turbolinks.visit(url)
            }
        }
    }

    $input.easyAutocomplete(options)
});
