# timeout = undefined

showMeMore = ->
  $("#more_items").hide()
  $(".loading").show()

  nb_items = $("tbody").children("tr").length

  $.ajax
    type: "GET"
    url: $(this).attr("action")
    data: offset: nb_items
    dataType: "script"
    success: ->
      $(".loading").hide()
      if $("tbody").children("tr").length >= $("#total").text()
        $("#more_items").hide()
      else
        $("#more_items").show()

# check = ->
#   if $(window).innerHeight() + $(window).scrollTop() >= $("body").height()
#     showMeMore()

# $(document).ready ->
#   $(window).scroll ->
#     if typeof timeout == "number"
#       # window.clearTimeout(Object timer)
#       # Suspend la minuterie timer déclarée par la méthode setTimeout().
#       window.clearTimeout timeout
#     # Object window.setTimeout(String fonc, Integer delai)
#     # Déclenche une minuterie et appelle le code javascript fonc dans delai millisecondes.
#     timeout = window.setTimeout(check, 250)

$(document).ready ->
  $("#more_items").click (e) ->
    e.preventDefault()
    showMeMore()
