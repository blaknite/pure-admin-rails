##
# Helper methods for use throughout the application.
module PureAdmin::PortletHelper
  ##
  # Renders a "portlet" to the view.
  # @param title (String)
  # @param options (Hash) a container for options to the portlet.
  # @param options[:portlet_html] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:title_html] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:body_html] (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the portlet
  def portlet(title, options = {}, &block)
    portlet_html = options[:portlet_html] || {}
    portlet_html[:class] = ['portlet', portlet_html[:class]]
    portlet_html[:data] = portlet_html[:data] || {}
    portlet_html[:data][:source] = options[:source] unless block_given?

    title_html = options.delete(:title_html) || {}

    body_html = options.delete(:body_html) || {}

    title = content_tag(:i, nil, class: "fa fa-fw fa-#{options[:icon]}") + h(title) if options[:icon]

    # This determines if the portlet can be closed. If it is remote it can be closed. If not,
    # it is determined by the presence of expand in the options.
    # e.g. <%= portlet 'A title', expand: true do %>...
    closable = options.key?(:source) || options.key?(:expand)

    portlet_html[:data][:closable] = closable

    if closable
      controls_content = content_tag(:div, class: 'portlet-controls') do
        content_tag(:span, nil, class: 'portlet-indicator')
      end
    end

    # This determines if the portlet should be expanded by default. If if is explicitly given that
    # takes precedence. If not, by default all remote portlets are not expanded and all static
    # portlets are.
    expand = options.key?(:expand) ? options[:expand] : block_given?

    if expand
      portlet_html[:class] << 'expanded'
      portlet_html[:data][:expand] = true
    end

    title_content = content_tag(:div, class: 'portlet-title') do
      content_tag(:h4, title) + ( controls_content || '' )
    end

    if block_given?
      body_content = content_tag(:div, { class: 'portlet-body clear-fix' }, &block)
    else
      body_content = content_tag(:div, '', { class: 'portlet-body clear-fix' })
    end

    portlet_html[:class] = portlet_html[:class].flatten.compact

    content_tag(:div, portlet_html) do
      title_content + body_content
    end
  end
end
