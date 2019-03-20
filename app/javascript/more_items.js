var showMeMore;

showMeMore = function() {
  var nb_items;
  $("#more_items").hide();
  $(".loading").show();
  nb_items = $("tbody").children("tr").length;
  return $.ajax({
    type: "GET",
    url: $(this).attr("action"),
    data: {
      offset: nb_items
    },
    dataType: "script",
    success: function() {
      $(".loading").hide();
      if ($("tbody").children("tr").length >= $("#total").text()) {
        return $("#more_items").hide();
      } else {
        return $("#more_items").show();
      }
    }
  });
};

$(document).ready(function() {
  return $("#more_items").click(function(e) {
    e.preventDefault();
    return showMeMore();
  });
});
