module PhlexHelper
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::RadioButton
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::FormTag
  include Phlex::Rails::Helpers::OptionsForSelect
  include Phlex::Rails::Helpers::SelectTag
  include Phlex::Rails::Helpers::HiddenFieldTag
  include Phlex::Rails::Helpers::CheckboxTag
  include Phlex::Rails::Helpers::FieldsFor

  extend ActiveSupport::Concern

  class_methods do
    def slots(*items)
      include Phlex::DeferredRender
      items.each do |item|
        define_method item.to_sym, -> (&block) { instance_variable_set("@#{item.to_s}", block) }
        define_method "#{item}?".to_sym, -> (&block) { instance_variable_get("@#{item.to_s}").present? }
      end
    end
  end
end