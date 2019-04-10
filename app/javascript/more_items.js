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
  // ↑ still jQuery ↑
};

function ready(fn) {
  if (document.attachEvent ? document.readyState === "complete" : document.readyState !== "loading"){
    fn();
  } else {
    document.addEventListener('DOMContentLoaded', fn);
  }
}

ready(function(){
  document.getElementById('more_items').onclick = function(event){
    event.preventDefault();
    showMeMore();
  };
});
