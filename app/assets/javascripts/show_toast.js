once_ready(function(){
  if (document.getElementById("debugToast") !== null ) {
    let debugToast = new bootstrap.Toast(document.getElementById("debugToast"));
    debugToast.show();
  };
});
