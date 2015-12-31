##
# Defines the :colour input type.
# @example <% f.input :colour, as: :colour %>
class ColourInput < SimpleForm::Inputs::StringInput
  extend PureAdmin::ApplicationHelper

  def input
    super
  end

  def input_html_classes
    super.push('pure-admin-colour-picker')
  end

  def input_html_options
    super.deep_merge(type: :text)
  end
end
