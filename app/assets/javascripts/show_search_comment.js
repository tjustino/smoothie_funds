once_ready(function(){
  function showOrHideSearchComment(searchOperator) {
    var searchComment = document.getElementById("search_comment");
    if (searchOperator[0].selected) {
      searchComment.style.display = "none";
    } else {
      searchComment.style.display = "block";
    }
  }

  if (document.getElementById("search_operator") !== null ) {
    var searchOperator = document.getElementById("search_operator");
    window.onload = function() {
      showOrHideSearchComment(searchOperator);
    }
    searchOperator.onchange = function(event) {
      event.preventDefault();
      showOrHideSearchComment(searchOperator);
    };
  }
});
