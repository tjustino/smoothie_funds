function getId(element) {
  return document.getElementById(element);
}

function countRowsTable(table) {
  if (getId(table) !== null ) {
    return getId(table).rows.length;
  }
}

window.addToTable = function (elements) {
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
