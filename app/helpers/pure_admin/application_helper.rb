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
end
