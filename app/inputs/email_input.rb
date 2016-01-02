##
# Overrides the :email input type to add a default prefix.
class EmailInput < SimpleForm::Inputs::StringInput
  extend PureAdmin::ApplicationHelper

  self.default_options = { prefix: '<i class="fa fa-fw fa-envelope"></i>'.html_safe }

  def input
    super
  end
end
