
##
# Helper methods to assist in building the Pure Admin menu.
module PureAdmin::MenuHelper
  ##
  # Renders a pure menu wrapper to the view.
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:animate] (Boolean) if this is false the 'with-animation' class will not be
  #   applied to the nested ul.
  # @param options[:horizontal] (Boolean) if this is false, the 'pure-menu-horizontal' class will
  #   not be applied to the wrapper tag.
  # @param options[:fixed] (Boolean) if this is false, the 'pure-menu-fixed' class will not be
  #   applied to the wrapper tag.
  # @param options[:main_menu] (Boolean) if this is false and no :id key has been supplied, the id
  #   'main-menu' will not be applied to the wrapper tag.
  # @yield The contents of the menu panel
  def menu(options = nil, &block)
    fail ArgumentError, 'You must supply a block.' unless block_given?

    if options
      opts = options.dup
    else
      opts = {}
    end

    inner_classes = ['pure-menu-list']
    inner_classes << 'with-animation' unless opts.delete(:animate) == false
    inner = content_tag(:ul, capture(&block), class: inner_classes)

    wrapper_classes = ['pure-menu']
    wrapper_classes << 'pure-menu-horizontal' unless opts.delete(:horizontal) == false
    wrapper_classes << 'pure-menu-fixed' unless opts.delete(:fixed) == false

    unless opts.delete(:main_menu) == false
      %w(left right).each do |dir|
        inner << content_tag(:div, content_tag(:span, nil, class: "fa fa-angle-double-#{dir}"),
          class: "fade-#{dir}", rel: 'main-menu-scroll', data: { direction: dir })
      end

      opts[:id] = 'main-menu' unless opts[:id].present?
    end

    opts[:class] = "#{wrapper_classes.join(' ')} #{opts[:class]}".strip
    content_tag(:div, content_tag(:nav, inner), opts)
  end

  ##
  # Renders a "menu item" to the view.
  # @param label (String, Symbol)
  # @param destination (String, Array)
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:icon] (String, Symbol) a FontAwesome icon name that will be prepended to the
  #   label.
  def menu_item(label = nil, destination = nil, options = nil, &block)
    if label.is_a?(Hash) && destination.nil? && options.nil? && block_given?
      # eg. menu_item(class: 'testing') do ...
      opts = label.dup
      label = nil
      destination = '#'
    elsif label.is_a?(Hash) && destination.nil? && options.nil? && !block_given?
      # eg. menu_item(class: 'testing')
      fail ArgumentError, 'Cannot build a menu item with only an options hash'
    elsif label.present? && destination.is_a?(Hash) && options.nil? && block_given?
      # eg. menu_item('destination', class: 'testing') do ...
      opts = destination.dup
      destination = label.to_s
      label = nil
    elsif label.present? && destination.is_a?(Hash) && options.nil? && !block_given?
      # eg. menu_item('destination', class: 'testing')
      opts = destination.dup
      destination = '#'
    elsif label.present? && destination.nil? && options.nil? && !block_given?
      # eg. menu_item 'destination'
      destination = '#'
      opts = {}
    elsif label.present? && destination.nil? && block_given?
      # eg. menu_item 'destination' do ...
      destination = label
      label = nil
      opts = options || {}
    elsif label.nil? && destination.nil? && options.nil? && block_given?
      # eg. menu_item do ...
      label = nil
      destination = '#'
      opts = {}
    elsif options
      opts = options.dup
    else
      opts = {}
    end

    fail ArgumentError, 'cannot supply both a label and a block' if label.present? && block_given?

    label = label.is_a?(Symbol) ? label.to_s.titleize : label

    link_text = ''.html_safe
    icon = opts.delete(:icon)
    link_text << content_tag(:i, nil, class: "fa fa-#{icon}") if icon.present?
    link_text << (block_given? ? capture(&block) : label)

    link_class = 'pure-menu-link'
    # TODO: when the implementation for multi-level menus is complete, consider what the parent
    # should do when children are current.
    link_class << ' current' if current_page?(destination) || label.to_s.downcase == controller_name

    link = link_to(link_text, destination, class: link_class)

    opts[:class] = "pure-menu-item #{opts[:class]}"
    content_tag(:li, link, opts)
  end
end
