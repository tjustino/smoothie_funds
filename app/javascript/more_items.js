var showMeMore = function() {
  var more_items = document.getElementById('more_items');
  var loading    = document.getElementsByClassName('loading')[0];
  var nb_items   = document.getElementById('listing').rows.length;
  var total      = document.getElementById('total');

  more_items.style.display = 'none';
  loading.style.display = '';

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

  // var request = new XMLHttpRequest();
  // request.open('GET', '?offset=' + nb_items, true);
  //
  // request.onload = function() {
  //   if (request.status >= 200 && request.status < 400) {
  //     loading.style.display = 'none';
  //     if (nb_items >= total.textContent) {
  //       more_items.style.display = 'none';
  //     } else {
  //       more_items.style.display = '';
  //     }
  //
  //     return request.response;
  //   } else {
  //     console.log("We reached our target server, but it returned an error 😵");
  //   }
  // };
  //
  // request.onerror = function() {
  //   console.log("There was a connection error 😵");
  // };
  //
  // request.send();
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
