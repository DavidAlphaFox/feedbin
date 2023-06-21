module Form
  class SelectInputComponent < ApplicationComponent
    include PhlexHelper
    include Phlex::DeferredRender

    slots :input

    def template
      render Form::TextInput.new do |input|
        input.input(&@input)
        input.accessory_trailing do
          render Svg.new "icon-caret", class: "fill-500 pg-focus:fill-blue-600 pg-disabled:fill-300"
        end
      end
    end
  end
end
