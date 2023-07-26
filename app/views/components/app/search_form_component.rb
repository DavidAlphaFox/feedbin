module App
  class SearchFormComponent < ApplicationComponent
    def initialize(params:)
      @params = params
    end

    def template
      div class: "search-wrap grid overflow-hidden min-h-0 group opacity-0 [grid-template-rows:0fr] data-[search-form-visible-value=true]:[grid-template-rows:1fr] data-[search-form-visible-value=true]:opacity-100 data-[search-form-foreground-value=true]:overflow-visible transition-[grid-template-rows]", data: { controller: "search-form", action: "toggle-search@window->search-form#toggle show-search@window->search-form#show hide-search@window->search-form#hide show-search-controls@window->search-form#showSearchControls sourceable:selected@window->search-form#hide", search_form_visible_value: "false", search_form_foreground_value: "false", search_form_options_visible_value: "false", search_form_search_token_outlet: "[data-controller=search-token]" } do
        form_with url: search_entries_path, class: "search-form group min-h-0", remote: true, method: :get, autocomplete: "off", novalidate: true, data: { remote: true, behavior: "search_form", controller: "search-token", action: "click@window->search-token#clickOff keydown.up->search-token#navigate keydown.down->search-token#navigate search-token#search sourceable:selected@window->search-token#updateToken sourceable:source-target-connected@window->search-token#buildJumpable sourceable:source-target-disconnected@window->search-token#buildJumpable", search_token_token_visible_value: "false", search_token_autocomplete_visible_value: "false", search_token_sourceable_outlet: "[data-controller=sourceable]" } do
          hidden_field_tag :query_extra, "", data: {search_token_target: "queryExtra"}
          button type: "submit", class: "visually-hidden" do
          end
          div class: "text-sm text-600 group relative" do
            div class: "border-b bg-base z-10" do
              div class: "flex flex-row-reverse items-stretch rounded" do
                div class: "mr-2" do
                  render App::SpinnerComponent.new
                end

                search_field_tag :query, @params[:query], placeholder: "Search", autocorrect: "off", autocapitalize: "off", spellcheck: false , class: "leading-[43px] grow px-2 rounded min-w-0 bg-transparent peer", data: { search_token_target: "query focusable", search_form_target: "query", action: " keyup->search-token#keyup keydown->search-token#checkToken focus->search-token#focused " }

                div class: "shrink-0 flex group ml-2 items-center w-[17px] group-data-[search-token-token-visible-value=true]:tw-hidden" do
                  render SvgComponent.new "icon-search", class: "fill-400 pg-focus:fill-blue-600"
                end

                div class: "grid items-stretch min-h-0 min-w-0 p-1 pr-0 max-w-[40%] [grid-template-columns:0fr] group-data-[search-token-token-visible-value=true]:[grid-template-columns:1fr] transition-[grid-template-columns] overflow-hidden" do
                  button class: "flex min-w-0 items-center text-left gap-2 rounded bg-100 group/token opacity-0 group-data-[search-token-token-visible-value=true]:px-2 group-data-[search-token-token-visible-value=true]:opacity-100 transition duration-200", data_action: "search-token#deleteToken:prevent", title: "Remove filter" do
                    div class: "shrink-0 w-[20px] h-[20px] rounded-[1px] flex items-center justify-center", data_search_token_target: "tokenIcon" do
                    end
                    div class: "truncate grow", data_search_token_target: "tokenText" do
                    end
                    render SvgComponent.new "icon-close-small", class: "shrink-0 transition fill-400 group-hover/token:fill-600 "
                  end
                end
              end
            end

            div class: "absolute z-50 inset-x-0 top-full w-full origin-top-left p-1 rounded-b bg-base shadow-two focus:outline-none group-data-[search-token-autocomplete-visible-value=false]:tw-hidden" do
              render App::SearchTokenResultComponent.new do |item|
                item.icon do
                  render SvgComponent.new "icon-search", class: "fill-400"
                end
                item.text do
                  plain "Search for "
                  span class: "font-bold", data_search_token_target: "preview" do
                  end
                  span class: "font-bold before:content-['_in_'] before:font-normal empty:before:tw-hidden", data_search_token_target: "previewSource" do
                  end
                end
              end

              div data_search_token_target: "results" do
              end
            end

            template_tag data_search_token_target: "resultTemplate" do
              render App::SearchTokenResultComponent.new do |item|
                item.icon do
                  render SvgComponent.new "favicon-tag", class: "fill-400"
                end
              end
            end

            template_tag data_search_token_target: "headerTemplate" do
              h2 class: "font-bold mx-2 uppercase mb-2 mt-4 text-500 text-xs", data_template: "text" do
              end
            end

            template_tag data_search_token_target: "tagIconTemplate" do
              render SvgComponent.new "favicon-tag", class: "fill-400"
            end
          end

        end

        div class: "grid overflow-hidden min-h-0 opacity-0 transition-[grid-template-rows] [grid-template-rows:0fr] group-data-[search-form-options-visible-value=true]:[grid-template-rows:1fr] group-data-[search-form-options-visible-value=true]:opacity-100 group-data-[search-form-options-visible-value=true]:overflow-visible" do
          div class: "min-h-0" do
            div class: "border-b flex gap-2 text-sm p-1 items-stretch" do
              div class: "dropdown-wrap" do
                button class: "flex gap-1 fill-500 items-center p-2 border rounded", data_behavior: "toggle_dropdown" do
                  span data_search_form_target: "sortLabel" do
                    "Sort by date"
                  end
                  render SvgComponent.new "icon-caret-small", class: "relative bottom-[-1px]"
                end
                div class: "dropdown-content" do
                  ul do
                    li do
                      button data_action: "search-form#changeSearchSort", data_search_form_target: "sortOption", data_sort_option: "desc" do
                        "Sort by date"
                      end
                    end
                    li do
                      button data_action: "search-form#changeSearchSort", data_search_form_target: "sortOption", data_sort_option: "relevance" do
                        "Sort by relevance"
                      end
                    end
                  end
                end
              end
              link_to "Save Search", new_saved_search_path, remote: true, class: "ml-auto !text-600 font-bold hover:no-underline text-xs flex items-center px-2 border border-transparent", data: {behavior: "open_settings_modal", search_form_target: "saveSearch"}
            end
          end
        end
      end
    end
  end
end