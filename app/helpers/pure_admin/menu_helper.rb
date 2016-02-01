
##
# Helper methods to assist in building the Pure Admin menu.
module PureAdmin::MenuHelper
  ##
  # Renders a pure menu wrapper to the view.
  # @param options (Hash) a container for options to be passed to menus and menu lists.
  # @param options[:menu_html] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:list_html] (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the menu panel
  def menu(options = {}, &block)
    menu_html = options.delete(:menu_html) || {}
    menu_html[:class] = merge_html_classes('pure-menu', menu_html[:class])

    list_html = options.delete(:list_html) || {}
    list_html[:class] = merge_html_classes('pure-menu-list', list_html[:class])

    content_tag(:nav, menu_html) do
      content_tag(:ul, '', list_html, &block)
    end
  end

  ##
  # Renders a pure sub-menu to the view.
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the menu panel
  def sub_menu(options = {}, &block)
    options[:class] = merge_html_classes('pure-menu-list sub-menu', options[:class])
    content_tag(:ul, '', options, &block)
  end

  ##
  # Renders a "menu link" to the view.
  # @param name (String, Symbol)
  # @param url (String, Array)
  # @param options (Hash) all options that can be passed to link_to are respected here.
  def menu_link(name = nil, url = nil, options = nil, &block)
    options, url, name = url, name, capture(&block) if block_given?
    options ||= {}

    name = name.to_s.titleize unless block_given? || name.respond_to?(:titleize)

    options[:class] = merge_html_classes('pure-menu-link', options[:class])

    url.present? ? link_to(name, url, options) : content_tag(:span, name, options)
  end

  ##
  # Renders a "menu item" to the view.
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  def menu_item(options = {}, &block)
    options[:class] = merge_html_classes('pure-menu-item', options[:class])
    options[:class] << 'current' if options.delete(:current)

    condition = options.key?(:if) ? options.delete(:if) : true
    condition = !options.delete(:unless) if options.key?(:unless)

    content_tag(:li, capture(&block), options) if condition
  end

  ##
  # Renders a "menu item" and "menu link" to the view.
  # @param name (String, Symbol)
  # @param url (String, Array)
  # @param options (Hash) a container for options to be passed to menu items and links.
  # @param options[:item_html] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:link_html] (Hash) all options that can be passed to link_to are respected here.
  def menu_item_and_link(name = nil, url = nil, options = nil, &block)
    options, url, name = url, name, capture(&block) if block_given?
    options ||= {}

    item_html = options.delete(:item_html) || {}
    item_html[:class] = merge_html_classes('pure-menu-item', item_html[:class])
    item_html[:if] = options[:if] if options.key?(:if)
    item_html[:unless] = options[:unless] if options.key?(:unless)
    item_html[:current] = true if current_menu_item?(url)

    link_html = options.delete(:link_html) || {}

    menu_item(item_html) do
      menu_link(name, url, link_html)
    end
  end

  ##
  # Check if the menu item is currently active
  # @param url (String) the menu item's URL.
  def current_menu_item?(url)
    return false unless url

    begin
      menu_item_path = URI.parse(url).try(:path)
    rescue
      menu_item_path = nil
    end

    return false unless menu_item_path

    # only match roots on exact match
    return request.original_fullpath == menu_item_path
  end

  ##
  # Check if the menu item is currently active. Is active if it is parent or current.
  # @param url (String) the menu item's URL.
  def current_parent?(url)
    return false unless url

    begin
      menu_item_path = URI.parse(url).try(:path)
    rescue
      menu_item_path = nil
    end

    return false unless menu_item_path

    # match all other items to start of original_fullpath
    return request.original_fullpath =~ /^#{Regexp.escape(menu_item_path)}(\/|$)/
  end
end
