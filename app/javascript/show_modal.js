// import { once_ready } from 'once_ready';
//
// once_ready(function(){
//   // ↓ still jQuery - waiting v5: https://github.com/twbs/bootstrap/pull/23586 ↓
//   $('#welcomeModal').modal('show');
//   // ↑ still jQuery - waiting v5: https://github.com/twbs/bootstrap/pull/23586 ↑
// });

// var welcomeModal = document.getElementById('welcomeModal')
// welcomeModal.modal('show');

console.log(bootstrap.Tooltip.VERSION);

let welcomeModal = new bootstrap.Modal(document.getElementById('welcomeModal'));
welcomeModal.show();
// welcomeModal.focus();
// var welcomeModal = document.getElementById('welcomeModal');
// myModal.show(modalToggle);
// var welcomeModal = document.getElementById('welcomeModal');
// welcomeModal.addEventListener('show.bs.modal', function (event) {
//   show();
// })
