var showMeMore = function() {
  var more_items = document.getElementById('more_items');
  var loading    = document.getElementsByClassName('loading')[0];
  var nb_items   = document.getElementById('listing').rows.length;
  var total      = document.getElementById('total');
  var csrf_token = document.querySelector("meta[name='csrf-token']").getAttribute('content');
  var action     = document.querySelector('form.button_to').getAttribute('action');

  more_items.style.display = 'none';
  loading.style.display = '';

  var request = new XMLHttpRequest();
  request.open('GET', action + '?offset=' + nb_items, true);
  request.setRequestHeader('X-CSRF-Token', csrf_token);
  request.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
  request.setRequestHeader('Accept', 'text/javascript');

  request.onload = function() {
    if (this.status >= 200 && this.status < 400) {
      loading.style.display = 'none';
      eval(this.response);

      if (document.getElementById('listing').rows.length >= total.textContent) {
        more_items.style.display = 'none';
      } else {
        more_items.style.display = '';
      }
    } else {
      console.log('We reached the target server, but it returned an error 😵');
    }
  };

  request.onerror = function() {
    console.log('There was a connection error 😵');
  };

  request.send();
};

once_ready(function(){
  if (document.getElementById('more_items') !== null ) {
    document.getElementById('more_items').onclick = function(event){
      event.preventDefault();
      showMeMore();
    };
  };
});
