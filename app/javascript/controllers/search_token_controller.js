import { Controller } from "@hotwired/stimulus";
import { hydrate } from "helpers";

// Connects to data-controller="search-token"
export default class extends Controller {
  static targets = [
    "query",
    "queryExtra",
    "focusable",
    "preview",
    "previewSource",
    "results",
    "resultTemplate",
    "headerTemplate",
    "tagIconTemplate",
    "tokenText",
    "tokenIcon",
  ];
  static values = {
    tokenVisible: Boolean,
    autocompleteVisible: Boolean,
  };

  connect() {
    this.currentFocusable = this.focusableTargets[0];
    this.buildJumpable();
  }

  search() {
    this.hideAutocomplete();
    this.skipFocus = true;
  }

  hideSearch() {
    this.queryTarget.value = "";
    this.deleteToken();
    this.hideAutocomplete();
    this.focusableTargets.forEach((element) => element.blur());
  }

  hideAutocomplete() {
    this.currentFocusable = this.focusableTargets[0];
    this.autocompleteVisibleValue = false;
  }

  deleteToken() {
    this.currentFocusable = this.focusableTargets[0];
    this.tokenVisibleValue = false;
    this.tokenTextTarget.innerHTML = "";
    this.tokenIconTarget.innerHTML = "";
    this.queryTarget.focus();
    this.queryExtraTarget.value = "";

    this.updatePreview();
  }

  clickOff(event) {
    if (event && this.element.contains(event.target)) {
      return;
    }
    this.hideAutocomplete();
  }

  tokenSelected(event) {
    let index = event.params.index;
    if (index === "") {
      let form = this.queryTarget.closest("form");
      window.$(form).submit();
    } else {
      let item = this.jumpableItems[event.params.index];
      window.feedbin.jumpTo(window.$(item.element));
      this.tokenTextTarget.textContent = item.title;
      this.tokenIconTarget.innerHTML = "";
      if ("icon" in item) {
        this.tokenIconTarget.append(item.icon.cloneNode(true));
      }
      this.tokenVisibleValue = true;
      this.queryTarget.value = "";
      this.queryTarget.focus();
      this.queryExtraTarget.value = `${item.type}_id:${item.id}`;
      window.feedbin.retainSearch = true;
    }
    this.hideAutocomplete();
    this.resultsTarget.innerHTML = "";
    event.preventDefault();
  }

  buildAutocomplete() {
    if (this.tokenVisibleValue) {
      return;
    }

    const resultTemplate = this.resultTemplateTarget.content;
    const headerTemplate = this.headerTemplateTarget.content;

    let items = this.jumpableItems.filter((item) => {
      const titleFolded = item.title.foldToASCII();
      const queryFolded = this.queryTarget.value.foldToASCII();
      item.score = titleFolded.score(queryFolded);
      return item.score > 0;
    });
    items = window._.sortBy(items, function (item) {
      return -item.score;
    });
    items = window._.groupBy(items, function (item) {
      return item.section;
    });

    let elements = [];
    const sections = Object.keys(items);
    sections.sort();
    sections.forEach((section) => {
      let header = headerTemplate.cloneNode(true);
      let element = hydrate(header, [
        {
          type: "text",
          name: "text",
          value: section,
        },
      ]);
      elements.push(element);
      items[section].slice(0, 5).forEach((item) => {
        let element = resultTemplate.cloneNode(true);
        let updates = [
          {
            type: "text",
            name: "text",
            value: item.title,
          },
          {
            type: "attribute",
            name: `data-${this.identifier}-index-param`,
            value: item.index,
          },
        ];

        if ("icon" in item) {
          updates.push({
            type: "html",
            name: "icon",
            value: item.icon.cloneNode(true),
          });
        }

        elements.push(hydrate(element, updates));
      });
    });

    this.resultsTarget.innerHTML = "";
    this.resultsTarget.append(...elements);
  }

  updatePreview() {
    this.previewTarget.textContent = this.queryTarget.value;

    let sourceText = "";
    if (this.tokenTextTarget.textContent != "") {
      sourceText = this.tokenTextTarget.textContent;
    }
    this.previewSourceTarget.textContent = sourceText;
  }

  keyup() {
    if (!this.skipFocus && this.queryTarget.value.length > 0) {
      this.autocompleteVisibleValue = true;
    } else {
      this.hideAutocomplete();
    }

    this.skipFocus = false;
    this.updatePreview();
    this.buildAutocomplete();
  }

  backspaceKey() {
    if (this.queryTarget.value.length === 0) {
      this.deleteToken();
    }
  }

  focused() {
    if (this.tokenVisibleValue) {
      return;
    }
    if (this.queryTarget.value.length > 0) {
      this.autocompleteVisibleValue = true;
    }
    this.buildJumpable();
  }

  navigate(event) {
    const count = this.focusableTargets.length;
    if (!this.autocompleteVisibleValue || count == 0) {
      return;
    }

    const currentIndex = this.focusableTargets.indexOf(this.currentFocusable);

    let nextIndex = (currentIndex + 1) % count;
    if (event.key === "ArrowUp") {
      nextIndex = (currentIndex + count - 1) % count;
    }

    this.currentFocusable = this.focusableTargets[nextIndex];
    this.currentFocusable.focus();

    if ("setSelectionRange" in this.currentFocusable) {
      this.currentFocusable.setSelectionRange(
        this.currentFocusable.value.length,
        this.currentFocusable.value.length
      );
    }

    event.preventDefault();
    event.stopPropagation();
  }

  buildJumpable() {
    const jumpable = document.querySelectorAll("[data-jumpable]");
    const tagIconTemplate = this.tagIconTemplateTarget.content;
    const items = Array.from(jumpable).map((element, index) => {
      let data = JSON.parse(element.dataset.jumpable);
      const icon =
        element.querySelector(".favicon-wrap") ||
        tagIconTemplate.cloneNode(true);
      data["icon"] = icon.cloneNode(true);
      data["element"] = element;
      data["index"] = index;

      return data;
    });

    this.jumpableItems = items;
  }
}
