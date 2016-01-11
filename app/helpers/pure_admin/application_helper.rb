##
# Helper methods for use throughout the application.
module PureAdmin::ApplicationHelper
  ##
  # Renders a "portlet" to the view.
  # @param title (String)
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the portlet
  def portlet(title = nil, options = nil, &block)
    if options.nil? && title.is_a?(Hash)
      opts = title.dup
      title = nil
    elsif options
      opts = options.dup
    else
      opts = {}
    end

    opts[:data] = opts[:data] || {}

    # This determines if the portlet can be closed. If it is remote it can be closed. If not,
    # it is determined by the presence of expand in the options.
    # e.g. <%= portlet 'A title', expand: true do %>...
    closable = block_given? ? opts.key?(:expand) : true

    # This determines if the portlet should be expanded by default. If if is explicitly given that
    # takes precedence. If not, by default all remote portlets are not expanded and all static
    # portlets are.
    if opts.key?(:expand)
      expand = opts.delete(:expand)
    else
      expand = (block_given? ? true : false)
    end

    inner = ''.html_safe
    unless title.blank?
      title_content = ''.html_safe
      if opts[:icon]
        title = title.prepend(content_tag(:i, nil, class: "fa fa-fw fa-#{opts[:icon]}")).html_safe
      end
      title_content << content_tag(:h4, title)

      indicator = ''.html_safe
      if closable
        indicator << content_tag(:span, '', class: 'portlet-indicator')
        opts[:data][:source] = opts.delete(:source) unless block_given?
      end

      title_content << content_tag(:div, indicator, class: 'portlet-controls') unless indicator.blank?

      inner << content_tag(:div, title_content, class: 'portlet-title')
    end

    portlet_body = block_given? ? capture(&block) : ''
    inner << content_tag(:div, portlet_body, class: 'portlet-body clear-fix')

    opts[:class] = "portlet #{opts[:class]}"
    opts[:data][:closable] = closable

    if expand
      opts[:class] << ' expanded'
      opts[:data][:expand] = true
    end

    content_tag(:div, inner, opts)
  end
end
