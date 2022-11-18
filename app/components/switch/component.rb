class Switch::Component < ApplicationViewComponent
  renders_one :description

  def initialize(title:)
    @title = title
  end
end
