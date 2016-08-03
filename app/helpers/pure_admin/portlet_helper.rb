##
# Helper methods to assist in building Pure Admin portlets.
module PureAdmin::PortletHelper
  ##
  # Renders a "portlet" to the view.
  # @param title (String)
  # @param options (Hash) a container for options to the portlet.
  # @param options[:portlet_html] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:heading_html] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:body_html] (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the portlet
  def portlet(title, options = {}, &block)
    portlet_html = options[:portlet_html] || {}
    portlet_html[:class] = ['portlet clear-fix', portlet_html[:class]]
    portlet_html[:data] ||= {}
    portlet_html[:data][:source] = options[:source] unless block_given?

    heading_html = options.delete(:heading_html) || {}
    heading_html[:class] = merge_html_classes('portlet-heading', heading_html[:class])

    body_html = options.delete(:body_html) || {}
    body_html[:class] = merge_html_classes('portlet-body clear-fix', body_html[:class])

    if options[:icon]
      icon = content_tag(:i, nil, class: "portlet-heading-icon fa fa-fw fa-#{options[:icon].to_s.dasherize}")
    end

    # This determines if the portlet can be closed. If it is remote it can be closed. If not,
    # it is determined by the presence of expand in the options.
    # e.g. <%= portlet 'A title', expand: true do %>...
    closable = options.key?(:source) || options.key?(:expand)

    portlet_html[:data][:closable] = closable

    controls_content = ''.html_safe
    controls = options.delete(:controls)
    if controls.present?
      if controls.respond_to?(:each)
        controls.each do |control|
          controls_content << content_tag(:span, control, class: 'portlet-control-item')
        end
      else
        controls_content << content_tag(:span, controls, class: 'portlet-control-item')
      end
    end

    if closable
      controls_content << content_tag(:span, nil, class: 'portlet-indicator')
    end

    if controls_content.present?
      controls_wrapper = content_tag(:div, controls_content, class: 'portlet-controls')
    end

    # This determines if the portlet should be expanded by default. If it is explicitly given that
    # takes precedence. If not, by default all remote portlets are not expanded and all static
    # portlets are.
    expand = options.key?(:expand) ? options[:expand] : block_given?

    if expand
      portlet_html[:class] << 'expanded'
      portlet_html[:data][:expand] = true
    end

    heading_content = content_tag(:div, heading_html) do
      (icon || ''.html_safe) + content_tag(:h4, title) + (controls_wrapper || ''.html_safe)
    end

    body_content = content_tag(:div, (capture(&block) if block_given?), body_html)

    content_tag(:div, portlet_html) do
      heading_content + body_content
    end
  end
end
