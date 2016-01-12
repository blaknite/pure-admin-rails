##
# Helper methods for the details panel.
module PureAdmin::DetailsPanelHelper
  ##
  # Renders a "details panel" to the view.
  # @param title (String)
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the details panel
  def details_panel(options = {}, &block)
    options[:class] = merge_html_classes('pure-g details-panel', options[:class])
    content_tag(:div, options, &block)
  end

  ##
  # Renders a "details panel item" to the view.
  # @param label (String, Symbol)
  # @param value (Any)
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the details panel item
  def details_panel_item(label, value = nil, options = nil, &block)
    options, value = value, capture(&block) if block_given?
    options = options || {}

    label = label.to_s.titleize unless label.nil? || label.respond_to?(:titleize)

    item_html = options.delete(:item_html) || {}
    item_html[:class] = merge_html_classes('details-panel-item pure-u-1', item_html[:class])

    label_html = options.delete(:label_html) || {}

    content_tag(:div, item_html) do
      content_tag(:label, label, label_html) + (value || '')
    end
  end

  ##
  # Renders a "details_panel_controls" element to the view.
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the details panel controls
  def details_panel_controls(options = {}, &block)
    options[:class] = merge_html_classes('details-panel-controls', options[:class])
    content_tag(:div, capture(&block), options)
  end
end
