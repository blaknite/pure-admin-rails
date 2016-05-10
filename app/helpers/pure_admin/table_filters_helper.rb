##
# Helper methods for table filters functionality.
#
# The recommended way of using this helper is
#
#   filters_for admin_members_path do |filter|
#     filter.on :query                           the default is a text field
#     filter.on :answer, options: %w(Yes No)     if given an options hash, a select will be used
#     filter.on :status, as: :active_status      when given :active_status it will use the options
#                                                  All, Active, and Inactive and the default of
#                                                  Active. However these can be overridden by
#                                                  :options and :default respectively.
#     filter.on :starts_on, as: :date            when given :date, it will enable the pure_date
#                                                  input type
#  end
module PureAdmin::TableFiltersHelper
  ##
  # Renders the table filters form to the view.
  # @param path (String) the path for the form_tag
  # @param options (Hash) all options that can be passed to form_tag are respected here.
  # @yield The contents for the table filters
  def table_filters(path, options = {}, &block)
    options[:class] = merge_html_classes('pure-form pure-form-stacked table-filters
      js-partial-refresh clear-fix', options[:class])

    options[:remote] ||= true
    options[:method] ||= :get

    content = capture(&block)

    if content
      content << content_tag(:div, submit_tag('Go', class: 'pure-button pure-button-primary'),
        class: 'filter-group filter-submit')
      content << hidden_field_tag(:sort, params[:sort])
      content << hidden_field_tag(:reverse_order, params[:reverse_order])

      form_tag path, options do
        content
      end
    end
  end

  ##
  # Renders a table filter item to the view.
  # @param attribute (String, Symbol)
  # @param options (Hash)
  # @options options (Symbol) :type the type of field to display
  # @options options (Hash) :options the select options for select inputs
  # @options options (String) :default the default select option for select inputs
  # @options options (Hash) :input_html any data contained within this hash will be passed to
  #   the appropriate *_tag method
  # @options options (Boolean, String) :label the text to display as a label if a string. If false,
  #   this will prevent the label from being shown
  # @options options (Hash) :label_html any data contained within this hash will be passed to
  #   the content_tag builder for the label
  # @yield The contents of the table filter with the label (unless options[:label] is false)
  def table_filter_item(attribute, options = {}, &block)
    if block_given?
      field = capture(&block)
    else
      type = options.delete(:as) || :string

      # If we're given an options array, we assume it to be a select filter.
      # This allows for more concise code in the form
      #   table_filter_item :status, options: %w(Yes No)
      # or
      #   filter.on :status, options %W(Yes No)
      type = :select if options[:options].present?

      # We define the :active_status type to shortcut a common filter type.
      if type == :active_status
        type = :select
        options[:options] ||= %w(All Active Inactive)
        options[:default] ||= 'Active'
      end

      input_html = options.delete(:input_html) || {}
      input_html[:class] = merge_html_classes('filter-control', input_html[:class])

      # Defaulting to a simple text field, we choose which field to output here.
      # @note if at some point we wish to add a new field type, here is the place to add it
      case type
        when :select
          options[:options] ||= []
          field = select_tag(attribute,
            options_for_select(options[:options], params[attribute.to_sym] || options[:default]),
            input_html)
        when :date
          input_html[:class] = merge_html_classes('pure-admin-date', input_html[:class])
          field = text_field_tag(attribute, params[attribute.to_sym], input_html)
          icon = content_tag(:span, nil, class: 'input-addon fa fa-fw fa-calendar')
          field = content_tag(:div, icon + field, class: 'addon-wrapper')
        else # :string
          field = text_field_tag(attribute, params[attribute.to_sym], input_html)
      end
    end

    label = ''.html_safe
    if options[:label] != false
      label_html = options.delete(:label_html) || {}
      label_text = options.delete(:label) || attribute.to_s.titleize
      label = label_tag(attribute, label_text, label_html)
    end

    content_tag(:div, label + field, class: 'filter-group')
  end

  ##
  # Renders a table filters section to the view using the table filter builder DSL.
  # @param resource (ActiveRecord::Base) the model instance to build the table filters for.
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the table filters section
  def filters_for(path, options = {}, &block)
    builder = TableFiltersBuilder.new(self)
    table_filters(path, options) do
      capture(builder, &block)
    end
  end

  ##
  # Allows building of table filters using a custom DSL.
  #
  # <%= filters_for resources_path do |filter| %>
  #   <%= filter.on :query %>
  # <% end %>
  class TableFiltersBuilder
    ##
    # Creates an instance of TableFiltersBuilder
    # @param helper (ApplicationHelper) instance of application helper to allow access to view helpers.
    # @yield instance of TableFiltersBuilder
    def initialize(helper)
      @helper = helper
    end

    ##
    # Renders a table_filter_item inside the table_filters using a custom DSL.
    #
    # @param attribute (Symbol) the attribute on the resource
    # @param options (Hash) all options that can be passed to content_tag are respected here.
    # @yield The contents of the details panel item
    def on(attribute, options = {}, &block)
      if block_given?
        helper.table_filter_item(attribute, options, &block)
      else
        helper.table_filter_item(attribute, options)
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
