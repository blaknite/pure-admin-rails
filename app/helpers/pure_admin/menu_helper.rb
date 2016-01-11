
##
# Helper methods to assist in building the Pure Admin menu.
module PureAdmin::MenuHelper
  ##
  # Renders a pure menu wrapper to the view.
  # @param options (Hash) a container for options to be passed to menus and menu lists.
  # @param options[:menu_options] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:list_options] (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the menu panel
  def menu(options = nil, &block)
    options ||= {}

    menu_options = options.delete(:menu_options) || {}
    menu_options[:class] = ['pure-menu', menu_options[:class]]
    menu_options[:class].flatten!
    menu_options[:class].compact!

    list_options = options.delete(:list_options) || {}
    list_options[:class] = ['pure-menu-list', list_options[:class]]
    list_options[:class].flatten!
    list_options[:class].compact!

    content_tag(:nav, menu_options) do
      content_tag(:ul, '', list_options, &block)
    end
  end

  ##
  # Renders a "menu item" to the view.
  # @param name (String, Symbol)
  # @param url (String, Array)
  # @param options (Hash) a container for options to be passed to menu items and links.
  # @param options[:item_options] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:link_options] (Hash) all options that can be passed to link_to are respected here.
  def menu_item(name = nil, url = nil, options = nil, &block)
    options, url, name = url, name, nil if block_given?

    name = name.to_s.titleize unless name.nil? || name.respond_to?(:titleize)
    options ||= {}

    item_options = options.delete(:item_options) || {}
    item_options[:class] = ['pure-menu-item', item_options[:class]]
    # TODO: Properly handle current page to take into account multi-level menus.
    if url.present? && ( current_page?(url) || name.to_s.downcase == controller_name )
      item_options[:class] << 'current'
    end
    item_options[:class].flatten!
    item_options[:class].compact!

    link_options = options.delete(:link_options) || {}
    link_options[:class] = ['pure-menu-link', link_options[:class]]
    link_options[:class].flatten!
    link_options[:class].compact!

    content_tag(:li, item_options) do
      if url.present?
        block_given? ? link_to(url, link_options, &block) : link_to(name, url, link_options)
      else
        block_given? ? content_tag(:span, link_options, &block) : content_tag(:span, name, link_options)
      end
    end
  end

  ##
  # Renders a "menu item" to the view if the condition is true.
  # @param condition (Boolean) the condition to be evaluated
  # @param name (String, Symbol)
  # @param url (String, Array)
  # @param options (Hash) a container for options to be passed to menu items and links.
  # @param options[:item_options] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:link_options] (Hash) all options that can be passed to link_to are respected here.
  def menu_item_if(condition, name = nil, url = nil, options = nil, &block)
    menu_item(name, url, options, &block) if condition
  end

  ##
  # Renders a "menu item" to the view if the condition is false.
  # @param condition (Boolean) the condition to be evaluated
  # @param name (String, Symbol)
  # @param url (String, Array)
  # @param options (Hash) a container for options to be passed to menu items and links.
  # @param options[:item_options] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:link_options] (Hash) all options that can be passed to link_to are respected here.
  def menu_item_unless(condition, name = nil, url = nil, options = nil, &block)
    !menu_item_if(condition, name, url, options, &block)
  end
end
