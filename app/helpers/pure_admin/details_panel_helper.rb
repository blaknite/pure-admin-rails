##
# Helper methods for the details panel.
module PureAdmin::DetailsPanelHelper
  ##
  # Renders a "details panel" to the view.
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the details panel
  def details_panel(options = {}, &block)
    options[:class] = merge_html_classes('pure-g details-panel', options[:class])
    content_tag(:div, options, &block)
  end

  ##
  # Renders a "details panel heading" to the view.
  # @param title (String)
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the details panel heading
  def details_panel_heading(title = nil, options = nil, &block)
    options, title = title, capture(&block) if block_given?
    options = options || {}
    options[:class] = merge_html_classes('pure-u details-panel-heading', options[:class])
    content_tag(:h4, title, options)
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

    value = value.try(:to_s)
    value = content_tag :span, '(blank)', class: 'text-muted' unless value.present?

    content_tag(:div, item_html) do
      content_tag(:label, label, label_html) + value
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

  ##
  # Renders a "details panel" to the view using the details panel builder DSL.
  # @param resource (ActiveRecord::Base) the model instance to build the details panel for.
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the details panel
  def details_panel_for(resource, options = {}, &block)
    builder = DetailsPanelBuilder.new(resource, self)
    details_panel(options) do
      capture(builder, &block)
    end
  end

  ##
  # Allows building of details panels using a custom DSL.
  #
  # <%= details_panel_for @resource do |dp| %>
  #   <%= dp.item :title %>
  # <% end %>
  class DetailsPanelBuilder
    ##
    # The resource to build the panel for.
    attr_reader :resource

    ##
    # Creates an instance of DetailsPanelBuilder
    # @param resource (ActiveRecord::Base) the model instance to build the details panel for.
    # @param helper (ApplicationHelper) instance of application helper to allow access to view helpers.
    # @yield instance of DetailsPanelBuilder
    def initialize(resource, helper)
      @resource = resource
      @helper = helper
    end

    ##
    # Renders a "details panel item" inside the "details panel" using a custom DSL.
    #
    # The attribute name is used as the item label with i18n. If a block is passed a custom
    # value can be given for the item. NoMethodError is thrown when the attribute is not
    # present on the resource.
    #
    # @param attribute (Symbol) the attribute on the resource
    # @param options (Hash) all options that can be passed to content_tag are respected here.
    # @yield The contents of the details panel item
    def item(attribute, options = {}, &block)
      human_attribute_name = resource.class.human_attribute_name(attribute) if resource.respond_to?(attribute)

      if block_given?
        helper.details_panel_item(human_attribute_name || attribute, options, &block)
      else
        helper.details_panel_item(human_attribute_name || attribute, resource.send(attribute), options)
      end
    end

    private

      ##
      # Access view helpers within the details panel builder
      # @yield instance of ApplicationHelper
      def helper
        @helper
      end
  end
end
