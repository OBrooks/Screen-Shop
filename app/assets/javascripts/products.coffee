# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
    $('#product_phone_model_id').parent().hide()
    phone_models= $('#product_phone_model_id').html()
    $('#product_phone_brand_id').change ->
        phone_brand = $('#product_phone_brand_id :selected').text()
        escaped_phone_brand = phone_brand.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
        console.log(phone_brand)
        options = $(phone_models).filter("optgroup[label='#{escaped_phone_brand}']").html()
        console.log(options)
        if options
            $('#product_phone_model_id').html(options)
            $('#product_phone_model_id').parent().show()
        else
            $('#product_phone_model_id').empty()
            $('#product_phone_model_id').parent().hide()

