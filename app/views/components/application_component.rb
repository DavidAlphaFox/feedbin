# frozen_string_literal: true

class ApplicationComponent < Phlex::HTML
  include Phlex::Rails::Helpers::CheckboxTag
  include Phlex::Rails::Helpers::SearchFieldTag
  include Phlex::Rails::Helpers::FieldsFor
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::FormTag
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::HiddenFieldTag
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::OptionsForSelect
  include Phlex::Rails::Helpers::RadioButton
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::SelectTag

  def self.slots(*items)
    include Phlex::DeferredRender
    items.each do |item|
      define_method item.to_sym, -> (&block) { instance_variable_set("@#{item.to_s}", block) }
      define_method "#{item}?".to_sym, -> (&block) { instance_variable_get("@#{item.to_s}").present? }
    end
  end

  def stimulus(controller, actions: {}, values: {}, outlets: {}, classes: {})
    stimulus_controller = controller.to_s.dasherize

    action = actions.map do |event, function|
      "#{event}->#{stimulus_controller}##{function.camelize(:lower)}"
    end.join(" ").presence

    values.transform_keys! do |key|
      :"#{key}_value"
    end

    outlets.transform_keys! do |key|
      :"#{key}_outlet"
    end

    classes.transform_keys! do |key|
      :"#{key}_class"
    end

    { controller: stimulus_controller, action:, controller => { **values, **outlets, **classes } }
  end

  def stimulus_item(target: nil, actions: {}, params: {}, data: {}, for:)
    action = actions.map do |event, function|
      "#{event}->#{binding.local_variable_get(:for)}##{function.to_s.camelize(:lower)}"
    end.join(" ").presence

    params.transform_keys! do |key|
      :"#{key}_param"
    end

    defaults = {
      action: action,
      binding.local_variable_get(:for) => { **params }
    }

    if target
      defaults[:"#{binding.local_variable_get(:for)}_target"] = target.to_s.camelize(:lower)
    end

    defaults.merge(data)
  end

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
