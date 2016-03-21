##
# Helper methods to render buttons.
module PureAdmin::ButtonHelper
  ##
  # @param options (Hash) all options that can be passed to button_tag are respected here.
  # @return (String) HTML for a save button.
  def save_button(options = {})
    options[:class] = merge_html_classes('pure-button pure-button-primary', options[:class])
    options[:type] ||= :submit
    button_tag('<i class="fa fa-fw fa-check"></i> Save'.html_safe, options)
  end

  ##
  # @param path (String, Array) the path for the edit button
  # @param options (Hash) all options that can be passed to link_to are respected here.
  # @return (String) HTML for the edit button.
  def edit_button(path, options = {})
    options[:class] = merge_html_classes('pure-button pure-button-primary', options[:class])
    link_to('<i class="fa fa-pencil"></i> Edit'.html_safe, path, options)
  end

  ##
  # @param path (String, Array) the path for the back button
  # @param options (Hash) all options that can be passed to link_to are respected here.
  # @return (String) HTML for the back button.
  def back_button(path = nil, options = {})
    options[:class] = merge_html_classes('pure-button', options[:class])
    link_to('Back', (path || :back), options)
  end

  ##
  # @param path (String, Array) the path for the back button
  # @param options (Hash) all options that can be passed to link_to are respected here.
  # @return (String) HTML for the cancel button.
  def cancel_button(path = nil, options = {})
    options[:class] = merge_html_classes('pure-button', options[:class])
    link_to('<i class="fa fa-ban"></i> Cancel'.html_safe, (path || :back), options)
  end

  ##
  # @param path (String, Array) the path for the delete button
  # @param options (Hash) all options that can be passed to link_to are respected here.
  # @options options :label the label for the delete button
  # @options options :icon the icon for the delete button
  # @return (String) HTML for the delete button.
  def delete_button(path, options = {})
    options[:class] = merge_html_classes('pure-button button-red', options[:class])
    options[:rel] ||= :modal
    options[:modal] ||= :confirm
    options[:data] ||= {}
    options[:data][:modal_request_method] ||= :delete

    label = options.delete(:label) || 'Delete'
    icon = options.delete(:icon) || 'fa-trash-o'

    link_to("<i class='fa #{icon}'></i> #{label}".html_safe, path, options)
  end
end
