##
# Overrides the :email input type to add a default prefix.
class AddonInput < SimpleForm::Inputs::StringInput
  extend PureAdmin::ApplicationHelper

  def icon
    if options[:icon].present?
      template.content_tag(:span, nil, class: ['input-addon', 'fa', 'fa-fw', options[:icon]])
    else
      ''
    end
  end

  def input(wrapper_options = nil)
    icon + super(wrapper_options)
  end
end
