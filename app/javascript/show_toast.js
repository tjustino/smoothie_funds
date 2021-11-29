import Toast from  "bootstrap/js/dist/toast";

if (document.getElementById("debugToast") !== null ) {
  let debugToast = new Toast(document.getElementById("debugToast"));
  debugToast.show();
};
