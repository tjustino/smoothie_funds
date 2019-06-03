import { once_ready } from 'once_ready';

once_ready(function(){
  $(".close.icon").on("click", function() {
    $(this).closest(".message").transition("scale");
  });
});
