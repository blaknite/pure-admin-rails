##
# Generic helper methods to be used throughout the Pure application.
module PureAdmin::ApplicationHelper
  ##
  # Merges two values into a new array while flattening and removing nils.
  # @param value1 (String, Array)
  # @param value2 (String, Array)
  # @return (Array)
  def merge_html_classes(value1, value2)
    [value1, value2].flatten.compact
  end

  ##
  # Provides a "nice" looking boolean display using tags.
  # @param (Boolean) value
  # @return (String) HTML
  def boolean_label(value)
    return value if value.nil?

    icon_class = 'fa'
    icon_class << (value ? ' fa-check' : ' fa-times')
    tag_class = 'tag'
    tag_class << ' tag-green' if value

    content_tag :span, content_tag(:i, '', class: icon_class), class: tag_class
  end
end
