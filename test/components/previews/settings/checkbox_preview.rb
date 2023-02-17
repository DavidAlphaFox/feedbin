class Settings::CheckboxPreview < Lookbook::Preview
  def default
    render Views::Components::Form::Checkbox.new
  end
end
