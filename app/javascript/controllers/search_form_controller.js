import { Controller } from "@hotwired/stimulus";
import { afterTransition } from "helpers";

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ["query", "sortLabel", "sortOption", "saveSearch"];
  static outlets = ["search-token"];
  static values = {
    visible: Boolean,
    foreground: Boolean,
    optionsVisible: Boolean,
  };

  connect() {
    this.element[this.identifier] = this;
  }

  show(event) {
    this.toggle(event, true);
  }

  hide(event) {
    this.toggle(event, false);
  }

  toggle(event, visible) {
    visible = typeof visible === "undefined" ? !this.visibleValue : visible;
    this.visibleValue = visible;
    if (!this.visibleValue) {
      this.hideSearchControls();
    } else {
      this.queryTarget.focus();
    }

    if (!this.visibleValue && this.hasSearchTokenOutlet) {
      this.searchTokenOutlet.hideSearch(event);
    }

    afterTransition(this.element, this.visibleValue, () => {
      this.foregroundValue = this.visibleValue;
    });
  }

  hideSearchControls() {
    this.optionsVisibleValue = false;
  }

  showSearchControls(event) {
    let { sort, query, savedSearchPath, message } = event.detail;
    sort = sort === "" ? "desc" : sort;
    let selected = this.sortOptionTargets.find((element) => {
      return element.dataset.sortOption === sort;
    });

    this.sortLabelTarget.textContent = selected.textContent;
    this.optionsVisibleValue = true;
    this.saveSearchTarget.setAttribute("href", savedSearchPath);

    document.body.classList.remove("nothing-selected", "entry-selected");
    document.body.classList.add("feed-selected");

    window.feedbin.markReadData = {
      type: "search",
      data: query,
      message: message,
    };
  }

  changeSearchSort(event) {
    let sortOption = event.target.dataset.sortOption;
    let value = this.queryTarget.value;
    value = value.replace(
      /\s*?(sort:\s*?asc|sort:\s*?desc|sort:\s*?relevance)\s*?/,
      ""
    );
    value = `${value} sort:${sortOption}`;
    this.queryTarget.value = value;

    let form = this.queryTarget.closest("form");

    window.$(form).submit();
  }
}
