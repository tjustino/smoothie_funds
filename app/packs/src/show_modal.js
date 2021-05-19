import { once_ready } from "./once_ready";
import { Modal } from "bootstrap";

once_ready(function(){
  if (document.getElementById("welcomeModal") !== null ) {
    let welcomeModal = new Modal(document.getElementById("welcomeModal"));
    welcomeModal.show();
  };
});
