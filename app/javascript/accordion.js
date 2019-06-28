import { once_ready } from 'once_ready';

once_ready(function(){
  $('.ui.accordion').accordion();

  // $('.ui.accordion>.title').on('click', function () {
  //   // alert('pouet');
  //   document.querySelector('script.transition.visible').style.display = 'none';
  //   alert('done');
  // });
});
