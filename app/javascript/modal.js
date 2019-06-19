import { once_ready } from 'once_ready';

once_ready(function(){
  $('#welcomeModal').modal('show');

  $("#importAccountsButton").click(function(){
    $("#importModal").modal('show');
  });
});
