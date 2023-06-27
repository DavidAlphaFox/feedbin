module Form
  class SelectInputComponent < ApplicationComponent
    include PhlexHelper

    slots :input, :label

    def template
      render Form::TextInputComponent.new do |input|
        input.label(&@label) if label?
        input.input(&@input)
        input.accessory_trailing do
          render SvgComponent.new "icon-caret", class: "fill-500 pg-focus:fill-blue-600 pg-disabled:fill-300"
        end
      end
    end
  end
end
