##
# Helper methods for the details panel.
module PureAdmin::DetailsPanelHelper
  ##
  # Renders a "details panel" to the view.
  # @param title (String)
  # @param options (Hash) a container for options to be passed to the panel and panel body.
  # @param options[:panel_html] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:body_html] (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the details panel
  def details_panel(options = nil, &block)
    options ||= {}

    panel_html = options.delete(:panel_html) || {}
    panel_html[:class] = merge_html_classes('details-panel', panel_html[:class])

    body_html = options.delete(:body_html) || {}
    body_html[:class] = merge_html_classes('details-panel-body pure-g', body_html[:class])

    content_tag(:div, panel_html) do
      content_tag(:div, '', body_html, &block)
    end
  end

  ##
  # Renders a "details panel item" to the view.
  # @param label (String, Symbol)
  # @param value (Any)
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the details panel item
  def details_panel_item(label = nil, value = nil, options = nil, &block)
    options, value = value, nil if block_given?

    label = label.to_s.titleize unless label.nil? || label.respond_to?(:titleize)

    options ||= {}
    options[:class] = merge_html_classes('details-item pure-u-1', options[:class])

    content_tag(:div, options) do
      content_tag(:label, label) + (block_given? ? capture(&block) : value.to_s)
    end
  end

  ##
  # Renders a "details_panel_controls" element to the view.
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the details panel controls
  def details_panel_controls(options = nil, &block)
    options ||= {}
    options[:class] = merge_html_classes('details-panel-controls pure-u-1', options[:class])
    content_tag(:div, capture(&block), options)
  end
end
