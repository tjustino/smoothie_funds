import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "checkboxOfTheDeath", "buttonOfTheDeath" ]

  checkboxOfTheDeathTargetConnected() {
    this.checkboxOfTheDeathTarget.checked = false
    this.buttonOfTheDeathTarget.disabled = true
  }

  toggleDeleteButton() {
    if (this.checkboxOfTheDeathTarget.checked) {
      // this.buttonOfTheDeathTarget.classList.add("is-loading")
      // setTimeout(function() {
      //   this.buttonOfTheDeathTarget.classList.remove("is-loading")
        this.buttonOfTheDeathTarget.disabled = false
      // }, 2000)
    } else {
      // this.buttonOfTheDeathTarget.classList.remove("is-loading")
      this.buttonOfTheDeathTarget.disabled = true
    }
  }
}
