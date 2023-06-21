module Form
  class TextInputComponent < ApplicationComponent
    include PhlexHelper
    include Phlex::DeferredRender

    slots :input, :label, :accessory_leading, :accessory_trailing, :accessory_leading_cap, :accessory_trailing_cap

    def template
      if label?
        div class: "mb-2 text-600", &@label
      end
      div data: {accessories: helpers.class_names(leading: accessory_leading?, trailing: accessory_trailing?, leadingCap: accessory_leading_cap?, trailingCap: accessory_trailing_cap?)}, class: "flex relative grow [&_input]:data-[accessories~=leading]:!pl-8 [&_input]:data-[accessories~=trailing]:!pr-8 [&_select]:data-[accessories~=leading]:!pl-8 [&_select]:data-[accessories~=trailing]:!pr-8 [&_input]:data-[accessories~=trailingCap]:!rounded-r-none" do
        whitespace &@input
        if accessory_leading?
          render InputAccesssory.new(&@accessory_leading)
        end
        if accessory_trailing?
          render InputAccesssory.new(position: "trailing", &@accessory_trailing)
        end
        if accessory_leading_cap?
          render InputAccesssory.new(&@accessory_leading_cap)
        end
        if accessory_trailing_cap?
          render InputAccesssory.new(position: "trailing", &@accessory_trailing_cap)
        end
      end
    end
  end
end
