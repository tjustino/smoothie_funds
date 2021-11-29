import Modal from  "bootstrap/js/dist/modal";

if (document.getElementById("welcomeModal") !== null ) {
  let welcomeModal = new Modal(document.getElementById("welcomeModal"));
  welcomeModal.show();
};
