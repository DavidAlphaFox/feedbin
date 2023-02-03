import { Controller } from "@hotwired/stimulus"
import { afterTransition } from "helpers"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ["query", "sortLabel", "sortOption", "saveSearch"]
  static outlets = ["search-token"]
  static values = {
    visible: Boolean,
    foreground: Boolean,
    optionsVisible: Boolean
  }

  connect() {
    this.element[this.identifier] = this
  }

  show(event) {
    this.toggle(event, true)
  }

  hide(event) {
    this.toggle(event, false)
  }

  toggle(event, visible) {
    visible = (typeof(visible) === "undefined") ? !this.visibleValue : visible
    this.visibleValue = visible
    if (!this.visibleValue) {
      this.optionsVisibleValue = false
    } else {
      this.queryTarget.focus()
    }

    if (!this.visibleValue && this.hasSearchTokenOutlet) {
      this.searchTokenOutlet.hideSearch(event)
    }

    afterTransition(this.element, this.visibleValue, () => {
      this.foregroundValue = this.visibleValue
    })
  }

  showSearchControls(event) {
    let {sort, query, savedSearchPath, message} = event.detail
    sort = (sort === "") ? "desc" : sort
    let selected = this.sortOptionTargets.find((element) => {
      return element.dataset.sortOption === sort
    })

    this.sortLabelTarget.textContent = selected.textContent
    this.optionsVisibleValue = true
    this.saveSearchTarget.setAttribute("href", savedSearchPath)

    document.body.classList.remove("nothing-selected", "entry-selected")
    document.body.classList.add("feed-selected")

    window.feedbin.markReadData = {
      type: "search",
      data: query,
      message: message
    }
  }

  changeSearchSort(event) {
    let sortOption = event.target.dataset.sortOption
    let value = this.queryTarget.value
    value = value.replace(/\s*?(sort:\s*?asc|sort:\s*?desc|sort:\s*?relevance)\s*?/, '')
    value = `${value} sort:${sortOption}`
    this.queryTarget.value = value

    let form = this.queryTarget.closest("form")

    $(form).submit()
  }

}


// showSearch: (val = '') ->
//   $('body').addClass('search')
//   $('body').removeClass('hide-search')
//   setTimeout ( ->
//     $('body').addClass('search-foreground')
//     field = $('[data-behavior~=search_form] input[type=search]')
//     field.focus()
//     field.val(val)
//   ), 150
//
// hideSearch: ->
//   $('body').removeClass('search show-search-options search-foreground')
//   $('body').addClass('hide-search')
//   field = $('[data-behavior~=search_form] input[type=search]')
//   field.blur()
//
// toggleSearch: ->
//   if $('body').hasClass('search')
//     feedbin.hideSearch()
//   else
//     feedbin.showSearch()
//
// showSearchControls: (sort, query, savedSearchPath, message) ->
//   text = null
//   if sort
//     text = $("[data-sort-option=#{sort}]").text()
//   if !text
//     text = $("[data-sort-option=desc]").text()
//   $('body').addClass('show-search-options')
//   $('body').addClass('feed-selected').removeClass('nothing-selected entry-selected')
//   $('.sort-order').text(text)
//   $('.search-control').removeClass('edit')
//   $('.saved-search-wrap').removeClass('show')
//   $('[data-behavior~=save_search_link]').removeAttr('disabled')
//   $('[data-behavior~=new_saved_search]').attr('href', savedSearchPath)
//   feedbin.markReadData =
//     type: "search"
//     data: query
//     message: message
//
// changeSearchSort: (sort) ->
//   $(document).on 'click', '[data-sort-option]', ->
//     sortOption = $(@).data('sort-option')
//     searchField = $('#query')
//     query = searchField.val()
//     query = query.replace(/\s*?(sort:\s*?asc|sort:\s*?desc|sort:\s*?relevance)\s*?/, '')
//     query = "#{query} sort:#{sortOption}"
//     searchField.val(query)
//     searchField.parents('form').submit()
//
// toggleSearch: ->
//   $(document).on 'click', '[data-behavior~=toggle_search]', (event) ->
//     feedbin.toggleSearch()
//
