jQuery ->
  $('.set_supplier_variant_cost input[type=text]').on 'change', ->
    $(@).parent('form').submit()
  $('.set_supplier_variant_cost').on 'submit', ->
    $.ajax
      type: @method
      url: @action
      data: $(@).serialize()
    false
