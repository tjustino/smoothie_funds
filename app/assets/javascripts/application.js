//= require rails-ujs
//= require bootstrap.bundle
//= require wNumb
//= require chart
//= require_tree .

function once_ready(callback) {
  // in case the document is already rendered
  if (document.readyState !== "loading") callback();
  // modern browsers
  else if (document.addEventListener) document.addEventListener("DOMContentLoaded", callback);
  // IE <= 8
  else document.attachEvent("onreadystatechange", function(){
    if (document.readyState === "complete") callback();
  });
}

function getId(element) {
  return document.getElementById(element);
}

function countRowsTable(table) {
  if (getId(table) !== null ) {
    return getId(table).rows.length;
  }
}

function addToTable(elements) {
  if (getId("listing") !== null && getId("offset") !== null && getId("total") !== null && getId("more-items") !== null) {
    getId("listing").insertAdjacentHTML("beforeend", elements);

    var tableLenght = countRowsTable("listing");
    getId("offset").value = tableLenght;

    if (tableLenght >= getId("total").textContent) {
      getId("more-items").remove();
    }
  } else {
    console.log("😵");
  }
}

function hexToRGB(hex, alpha) {
  var r = parseInt(hex.slice(1, 3), 16);
  var g = parseInt(hex.slice(3, 5), 16);
  var b = parseInt(hex.slice(5, 7), 16);

  if (alpha) {
    return "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")";
  } else {
    return "rgb(" + r + ", " + g + ", " + b + ")";
  }
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
