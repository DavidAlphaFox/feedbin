import { Controller } from "@hotwired/stimulus"
// import { debounce } from "helpers"

// Connects to data-controller="search-toggle"
export default class extends Controller {
  static outlets = ["search-form"]

  connect() {
    debounce()
  }

  toggle() {
    document.querySelector("[data-controller=search-form]")['search-form'].toggle()
  }
}
