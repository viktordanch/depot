$ ->
  $('.store .entry > img').click ->
    $(@).parent().find(':submit').click()