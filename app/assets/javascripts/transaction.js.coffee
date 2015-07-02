$(document).ready ->
  $("#more_transactions").click (e) ->
    e.preventDefault()

    $("#more_transactions").hide()
    $(".loading").show()

    nb_transactions = $("tbody").children("tr").length

    $.ajax
      type: "GET"
      url: $(this).attr("href")
      data: offset: nb_transactions
      dataType: "script"
      success: ->
        $(".loading").hide()
        if $("tbody").children("tr").length >= 35
          $("#more_transactions").hide()
        else
          $("#more_transactions").show()
