import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "accounts", "commentScope", "commentField", "searchDetail" ]

  commentScopeTargetConnected() {
    this.commentScopeTarget.selectedIndex = 0
    this.commentFieldTarget.style.display = "none"
  }

  toggleCategoriesLists() {
    var selected_accounts = []

    for(var i = 0, len = this.accountsTarget.options.length; i < len; i++) {
      var element = this.accountsTarget.options[i]
      selected_accounts.push({
        account_id: element.value,
        selected: element.selected
      })
    }

    for(var i = 0, len = selected_accounts.length; i < len; i++) {
      var account_categories = document.getElementById("categories_for_" + selected_accounts[i].account_id);
      if (selected_accounts[i].selected) {
        account_categories.style.display = "block";
      } else {
        account_categories.style.display = "none";
      }
    }
  }

  toggleCommentField() {
    if (this.commentScopeTarget[0].selected) {
      this.commentFieldTarget.style.display = "none"
    } else {
      this.commentFieldTarget.style.display = "block"
    }
  }

  toggleDetailHistory() {
    var contentElement = this.element.querySelector(".card-content")
    var chevronElement = this.element.querySelector("i.fa-solid")

    contentElement.classList.toggle("is-hidden")

    if (chevronElement !== null && chevronElement.classList.contains("fa-chevron-up")) {
      chevronElement.classList.replace("fa-chevron-up", "fa-chevron-down")
    } else if (chevronElement !== null && chevronElement.classList.contains("fa-chevron-down")) {
      chevronElement.classList.replace("fa-chevron-down", "fa-chevron-up")
    }
  }
}
