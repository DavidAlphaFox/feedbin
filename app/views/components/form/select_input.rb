module Views
  module Components
    module Form
      class SelectInput < Phlex::HTML
        include PhlexHelper
        include Phlex::DeferredRender

        slots :input

        def template
          render Components::Form::TextInput.new do |input|
            input.input(&@input)
            input.accessory_trailing do
              render Components::Svg.new "icon-caret", class: "fill-500 pg-focus:fill-blue-600 pg-disabled:fill-200"
            end
          end
        end
      end
    end
  end
end

