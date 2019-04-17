import { once_ready } from 'once_ready';

once_ready(function(){
  // ↓ still jQuery - waiting v5: https://github.com/twbs/bootstrap/pull/23586 ↓
  $('#welcomeModal').modal('show');
  // ↑ still jQuery - waiting v5: https://github.com/twbs/bootstrap/pull/23586 ↑
});
