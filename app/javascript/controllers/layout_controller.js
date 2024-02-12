import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "navBarBurger", "navBarMenu", "modal" ]

  toggleMenu() {
    this.navBarBurgerTarget.classList.toggle("is-active")
    this.navBarMenuTarget.classList.toggle("is-active")
  }

  removeMessageBox() {
    this.element.remove()
  }

  showModal() {
    this.modalTarget.classList.add("is-active")
  }

  hideModal() {
    this.modalTarget.classList.remove("is-active")
  }
}
