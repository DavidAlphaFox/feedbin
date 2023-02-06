import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="sourceable"
export default class extends Controller {

  static values = {
    params: Object
  }

  selected() {
    // const custom = new CustomEvent(`${this.identifier}-selected`, {detail: this.paramsValue});
    // window.dispatchEvent(custom);

    this.dispatch("selected", { detail: this.paramsValue })
  }
}