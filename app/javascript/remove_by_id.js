window.removeById = function(element) {
  if (document.getElementById(element) !== null ) {
    document.getElementById(element).remove();
  };
}
