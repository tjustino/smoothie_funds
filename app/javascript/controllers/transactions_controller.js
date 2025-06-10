import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleUpcoming() {
    document.querySelectorAll("tr.upcoming-transaction").forEach(tr => {
      tr.classList.toggle("is-hidden");
    })
  }
}
