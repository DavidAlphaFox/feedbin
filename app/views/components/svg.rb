module Views
  module Components
    class Svg < Phlex::HTML
      register_element :use

      def initialize(name, options = {})
        @name = name
        @options = options
      end

      def template(&)
        result = helpers.svg_options(@name, @options)
        inline = result.options.delete(:inline)
        svg(**result.options) do
          if inline
            unsafe_raw result.icon.markup
          else
            use href: "##{@name}"
          end
        end
      end
    end
  end
end
