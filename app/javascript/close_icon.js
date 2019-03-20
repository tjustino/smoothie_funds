import $ from "jquery";


$(document).ready(function() {
  return $(".close.icon").on("click", function() {
    return $(this).closest(".message").transition("scale");
  });
});
