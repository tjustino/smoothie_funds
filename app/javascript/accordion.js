// Show a modal referenced by an id
window.toggleAccordion = function(element) {
  var contentElement = element.parentElement.nextElementSibling;
  var chevronElement = element.querySelector("i.fa-solid");

  if (contentElement.classList.contains("card-content")) {
    contentElement.classList.toggle("is-hidden");

    if (chevronElement !== null && chevronElement.classList.contains("fa-chevron-up")) {
      chevronElement.classList.replace("fa-chevron-up", "fa-chevron-down");
    } else if (chevronElement !== null && chevronElement.classList.contains("fa-chevron-down")) {
      chevronElement.classList.replace("fa-chevron-down", "fa-chevron-up");
    }
  };
}