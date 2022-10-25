window.enableOrDisable = function() {
  if (document.getElementById("irreversibleCheckbox") !== null && document.getElementById("irreversibleButton") !== null) {
    let irreversibleCheckbox = document.getElementById("irreversibleCheckbox");
    let irreversibleButton = document.getElementById("irreversibleButton");
  
    if (irreversibleCheckbox.checked) {
      irreversibleButton.classList.add("is-loading")
      setTimeout(function() {
        irreversibleButton.classList.remove("is-loading");
        irreversibleButton.disabled = false;
      }, 2000)
    } else {
      irreversibleButton.classList.remove("is-loading");
      irreversibleButton.disabled = true;
    }
  };
}
