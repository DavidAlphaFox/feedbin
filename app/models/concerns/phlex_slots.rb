module PhlexSlots
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::RadioButton
  include Phlex::Rails::Helpers::Label

  extend ActiveSupport::Concern

  class_methods do
    def slots(*items)
      items.each do |item|
        define_method item.to_sym, -> (&block) { instance_variable_set("@#{item.to_s}", block) }
      end
    end
  end
end