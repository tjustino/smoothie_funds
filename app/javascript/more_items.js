var showMeMore = function() {
  document.getElementById('more_items').style.display = 'none';
  document.getElementsByClassName('loading')[0].style.display = '';
  var nb_items = document.getElementById('listing').rows.length;

  // ↓ still jQuery ↓
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
// ↑ still jQuery ↑
