class ControlGroup::Component < ViewComponent::Base
  renders_one :header
  renders_many :items
end
