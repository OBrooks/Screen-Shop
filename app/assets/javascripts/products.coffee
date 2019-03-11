# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready turbolinks:load', ->
    $('#product_phone_model_id').parent().parent().hide()
    phone_models= $('#product_phone_model_id').html()
    $('#product_phone_brand_id').change ->
        phone_brand = $('#product_phone_brand_id :selected').text()
        escaped_phone_brand = phone_brand.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
        options = $(phone_models).filter("optgroup[label='#{escaped_phone_brand}']").html()
        if options
            $('#product_phone_model_id').html(options)
            $('#product_phone_model_id').parent().parent().show()
        else
            $('#product_phone_model_id').empty()
            $('#product_phone_model_id').parent().parent().hide()

    
    status = $('#product_status :selected').text()
    if status == "Soldes"
        $("#discount").parent().show()
    else
        $("#discount").parent().hide()


    $('#product_status').change ->
        status = $('#product_status :selected').text()
        if status == "Soldes"
            $("#discount").parent().show()
        else
            $("#discount").parent().hide()


