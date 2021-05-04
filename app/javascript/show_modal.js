import { once_ready } from 'once_ready';

once_ready(function(){
  if (document.getElementById('welcomeModal') !== null ) {
    let welcomeModal = new bootstrap.Modal(document.getElementById('welcomeModal'));
    welcomeModal.show();
  };
});
