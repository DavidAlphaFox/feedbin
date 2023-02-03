import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event"
// data-event-identifier-param
// data-event-payload-param
export default class extends Controller {
  connect() {
    console.log('connect event');
  }
  dispatch(event) {
    console.log(event);
    console.log(event.params);
    const custom = new CustomEvent(event.params.identifier, event.params.payload)
    window.dispatchEvent(custom)
  }
}
