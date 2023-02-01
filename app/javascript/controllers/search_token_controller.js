import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-token"
export default class extends Controller {
  static targets = ["query", "focusable", "preview", "previewSource", "results", "resultTemplate", "headerTemplate", "tokenText", "tokenIcon"]
  static values = {
    tokenVisible: Boolean,
    autocompleteVisible: Boolean
  }

  connect() {
    this.currentFocusable = this.focusableTargets[0]
    this.buildJumpable()
  }

  search(event) {
    this.autocompleteVisibleValue = false
    this.queryTarget.blur()
  }

  deleteToken() {
    console.log("deleteTOken?");
    this.tokenVisibleValue = false
    this.tokenTextTarget.innerHTML = ""
    this.tokenIconTarget.innerHTML = ""
    this.queryTarget.focus()
  }

  clickOff(event) {
    if (event && this.element.contains(event.target)) {
      return
    }
    this.autocompleteVisibleValue = false
  }

  setText(element, selector, value) {
    let result = element.querySelector(`[data-template=${selector}]`)
    if (result) {
      result.textContent = value
    } else {
      console.log(`setText missing selector: ${selector}`);
    }
  }

  setHTML(element, selector, value) {
    let result = element.querySelector(`[data-template=${selector}]`)
    if (result) {
      result.innerHTML = ""
      result.append(value)
    } else {
      console.log(`setText missing selector: ${selector}`);
    }
  }

  tokenSelected(event) {
    let item = this.jumpableItems[event.params.index]
    feedbin.jumpTo($(item.element))
    this.autocompleteVisibleValue = false
    this.tokenTextTarget.textContent = item.title
    this.tokenIconTarget.innerHTML = ""
    if ("icon" in item) {
      this.tokenIconTarget.append(item.icon.cloneNode(true))
    }
    this.tokenVisibleValue = true
    this.resultsTarget.innerHTML = ""
    this.queryTarget.value = ""
    this.queryTarget.focus()
    window.feedbin.retainSearch = true
    event.preventDefault()
  }

  buildAutocomplete() {
    if (this.tokenVisibleValue) {
      return
    }

    const resultTemplate = this.resultTemplateTarget.content
    const headerTemplate = this.headerTemplateTarget.content

    let items = this.jumpableItems.filter((item) => {
      const titleFolded = item.title.foldToASCII()
      const queryFolded = this.queryTarget.value.foldToASCII()
      item.score = titleFolded.score(queryFolded)
      return item.score > 0;
    })
    items = _.sortBy(items, function(item) {
      return -item.score;
    })
    items = _.groupBy(items, function(item) {
      return item.section;
    })

    let elements = []
    const sections = Object.keys(items)
    sections.sort()
    sections.forEach((section) => {
      let header = headerTemplate.cloneNode(true)
      this.setText(header, "text", section)
      elements.push(header)
      items[section].slice(0, 5).forEach((item) => {
        let result = resultTemplate.cloneNode(true)
        this.setText(result, "text", item.title)

        let indexAttribute = `data-${this.identifier}-index-param`
        let index = result.querySelector(`[${indexAttribute}]`)
        if (index) {
          index.setAttribute(indexAttribute, item.index)
        }
        if ("icon" in item) {
          this.setHTML(result, "icon", item.icon.cloneNode(true))
        }
        elements.push(result)
      })
    })

    this.resultsTarget.innerHTML = ""
    this.resultsTarget.append(...elements)
  }

  keyup(event) {
    console.log(this.queryTarget.value);
    if (this.queryTarget.value.length > 0) {
      this.autocompleteVisibleValue = true
    } else {
      this.autocompleteVisibleValue = false
    }
    this.previewTarget.textContent = this.queryTarget.value

    let sourceText = ""
    if (this.tokenTextTarget.textContent != "") {
      sourceText = this.tokenTextTarget.textContent
    }
    this.previewSourceTarget.textContent = sourceText
    this.buildAutocomplete()
  }

  backspaceKey(event) {
    if (this.queryTarget.value.length === 0) {
      this.deleteToken()
    }
  }

  escapeKey(event) {
    this.autocompleteVisibleValue = false
    this.focusableTargets.forEach((element) => element.blur())
  }

  focused(event) {
    if (this.tokenVisibleValue) {
      return
    }
    if (this.queryTarget.value.length > 0) {
      this.autocompleteVisibleValue = true
    }
    this.buildJumpable()
  }

  navigate(event) {
    const count = this.focusableTargets.length
    if (!this.autocompleteVisibleValue || count == 0) {
      return
    }

    const currentIndex = this.focusableTargets.indexOf(this.currentFocusable)

    let nextIndex = (currentIndex + 1) % count
    if (event.key === "ArrowUp") {
      nextIndex = (currentIndex + count - 1) % count
    }

    this.currentFocusable = this.focusableTargets[nextIndex]
    this.currentFocusable.focus()

    if ("setSelectionRange" in this.currentFocusable) {
      this.currentFocusable.setSelectionRange(this.currentFocusable.value.length, this.currentFocusable.value.length)
    }

    event.preventDefault()
    event.stopPropagation()
  }

  buildJumpable() {
    const jumpable = document.querySelectorAll("[data-jumpable]")

    const items = Array.from(jumpable).map((element, index) => {
      let data = JSON.parse(element.dataset.jumpable)
      const icon = element.querySelector(".favicon-wrap")
      if (icon) {
        data["icon"] = icon.cloneNode(true)
      }
      data["element"] = element
      data["index"] = index

      return data
    })

    this.jumpableItems = items
  }

}
