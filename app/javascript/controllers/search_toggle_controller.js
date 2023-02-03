import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-toggle"
export default class extends Controller {
  toggle() {
    document.querySelector("[data-controller=search-form]")['search-form'].toggle()
  }
}
