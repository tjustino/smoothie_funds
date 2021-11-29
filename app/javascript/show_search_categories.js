function getSelectedElements(sel) {
  var selected_elements = [];
  for(var i = 0, len = sel.options.length; i < len; i++) {
    var element = sel.options[i];
    element_details = {
      account_id: element.value,
      selected: element.selected
    };
    selected_elements.push(element_details);
  }
  return selected_elements;
};

if (document.getElementById("search_accounts") !== null ) {
  var searchAccounts = document.getElementById("search_accounts");
  searchAccounts.onchange = function () {
    var selected_accounts = getSelectedElements(searchAccounts);
    for(var i = 0, len = selected_accounts.length; i < len; i++) {
      var account_categories = document.getElementById("categories_for_" + selected_accounts[i].account_id);
      if (selected_accounts[i].selected) {
        account_categories.style.display = "block";
      } else {
        account_categories.style.display = "none";
      }
    }
  };
}
