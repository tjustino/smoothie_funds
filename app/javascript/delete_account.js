function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}


async function enableOrDisableIrreversibleButton() {
  let irreversibleChoice = document.getElementById("irreversibleChoice");
  let irreversibleButton = document.getElementById("irreversibleButton");
  let irreversibleSpinner = document.getElementById("irreversibleSpinner");

  if (irreversibleChoice.checked) {
    irreversibleSpinner.classList.remove("visually-hidden");
    await sleep(2000);
    if (irreversibleChoice.checked) {
      irreversibleSpinner.classList.add("visually-hidden");
      irreversibleButton.disabled = false;
    }
  } else {
    if (!irreversibleSpinner.classList.contains("visually-hidden")) {
      irreversibleSpinner.classList.add("visually-hidden");
    }
    irreversibleButton.disabled = true;
  }
}

// once_ready(function(){
if (document.getElementById("irreversibleChoice") !== null ) {
  document.getElementById("irreversibleChoice").onclick = function(event){
    enableOrDisableIrreversibleButton();
  };
};
// });
