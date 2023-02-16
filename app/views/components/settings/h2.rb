module Views
  module Components
    module Settings
      class H2 < Phlex::HTML
        def template(&)
          h2(class: "mb-4 text-700 font-bold", &)
        end
      end
    end
  end
end