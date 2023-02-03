import { Controller } from "@hotwired/stimulus"
import { afterTransition } from "helpers"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = []
  static values = {
    visible: Boolean,
    foreground: Boolean,
    optionsVisible: Boolean
  }

  connect() {
    this.element[this.identifier] = this
  }

  toggle(event) {
    this.visibleValue = !this.visibleValue
    if (!this.visibleValue) {
      this.optionsVisibleValue = false
    }
    afterTransition(this.element, this.visibleValue, () => {
		  this.foregroundValue = this.visibleValue
		})
  }

  showSearchControls(sort, query, savedSearchPath, message) {
    var text;
    text = null;
    if (sort) {
      text = $("[data-sort-option=" + sort + "]").text();
    }
    if (!text) {
      text = $("[data-sort-option=desc]").text();
    }

    this.optionsVisibleValue = true

    $('body').addClass('feed-selected').removeClass('nothing-selected entry-selected');
    $('.sort-order').text(text);
    $('.search-control').removeClass('edit');
    $('.saved-search-wrap').removeClass('show');
    $('[data-behavior~=save_search_link]').removeAttr('disabled');
    $('[data-behavior~=new_saved_search]').attr('href', savedSearchPath);
    return feedbin.markReadData = {
      type: "search",
      data: query,
      message: message
    };
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
