import { once_ready } from 'once_ready';

once_ready(function(){
  return $(".close.icon").on("click", function() {
    return $(this).closest(".message").transition("scale");
  });
});
