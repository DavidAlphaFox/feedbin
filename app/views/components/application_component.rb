# frozen_string_literal: true

class ApplicationComponent < Phlex::HTML
	include Phlex::Rails::Helpers::Routes
  include PhlexHelper

	if Rails.env.development?
    def before_template
      comment { "Start: #{self.class.name}" }
      super
    end

    def after_template
      comment { "End: #{self.class.name}" }
      super
    end
	end
end
