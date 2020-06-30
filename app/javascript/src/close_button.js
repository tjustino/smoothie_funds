import { once_ready } from 'src/once_ready';

once_ready(function(){
  (document.querySelectorAll('#debug .delete') || []).forEach(
    (to_delete) => {
      var notification = to_delete.parentNode.parentNode;
      to_delete.addEventListener('click', () => {
        notification.parentNode.removeChild(notification);
    });
  })
});

once_ready(function(){
  (document.querySelectorAll('.notification .delete') || []).forEach(
    (to_delete) => {
      var notification = to_delete.parentNode;
      to_delete.addEventListener('click', () => {
        notification.parentNode.removeChild(notification);
    });
  })
});
