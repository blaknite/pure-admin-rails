##
# Overrides the :tel input type to add a default prefix.
class PhoneInput < SimpleForm::Inputs::StringInput
  extend PureAdmin::ApplicationHelper

  self.default_options = { prefix: '<i class="fa fa-phone"></i>'.html_safe }

  def input
    super
  end
end
