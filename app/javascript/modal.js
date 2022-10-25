// Show a modal referenced by an id
window.showModal = function(modal) {
  if (document.getElementById(modal) !== null && document.getElementById(modal).classList.contains("is-active") == false) {
    document.getElementById(modal).classList.add("is-active");
  };
}

// Hide a modal referenced by an id
window.hideModal = function(modal) {
  if (document.getElementById(modal) !== null ) {
    event.preventDefault()
    document.getElementById(modal).classList.remove("is-active");
  };
}
