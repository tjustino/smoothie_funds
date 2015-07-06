$(document).ready ->
  $("#more_items").click (e) ->
    e.preventDefault()

    $("#more_items").hide()
    $(".loading").show()

    nb_items = $("tbody").children("tr").length

    $.ajax
      type: "GET"
      url: $(this).attr("href")
      data: offset: nb_items
      dataType: "script"
      success: ->
        $(".loading").hide()
        if $("tbody").children("tr").length >= $("#total").text()
          $("#more_items").hide()
        else
          $("#more_items").show()
