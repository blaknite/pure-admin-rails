
##
# Helper methods to assist in building the Pure Admin menu.
module PureAdmin::MenuHelper
  ##
  # Renders a pure menu wrapper to the view.
  # @param options (Hash) a container for options to be passed to menus and menu lists.
  # @param options[:menu_html] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:list_html] (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the menu panel
  def menu(options = nil, &block)
    options ||= {}

    menu_html = options.delete(:menu_html) || {}
    menu_html[:class] = merge_options('pure-menu', menu_html[:class])

    list_html = options.delete(:list_html) || {}
    list_html[:class] = merge_options('pure-menu-list', list_html[:class])

    content_tag(:nav, menu_html) do
      content_tag(:ul, '', list_html, &block)
    end
  end

  ##
  # Renders a "menu item" to the view.
  # @param name (String, Symbol)
  # @param url (String, Array)
  # @param options (Hash) a container for options to be passed to menu items and links.
  # @param options[:item_html] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:link_html] (Hash) all options that can be passed to link_to are respected here.
  def menu_item(name = nil, url = nil, options = nil, &block)
    options, url, name = url, name, nil if block_given?

    name = name.to_s.titleize unless name.nil? || name.respond_to?(:titleize)
    options ||= {}

    item_html = options.delete(:item_html) || {}
    item_html[:class] = merge_options('pure-menu-item', item_html[:class])
    # TODO: Properly handle current page to take into account multi-level menus.
    if url.present? && ( current_page?(url) || name.to_s.downcase == controller_name )
      item_html[:class] << 'current'
    end

    link_html = options.delete(:link_html) || {}
    link_html[:class] = merge_options('pure-menu-link', link_html[:class])

    content_tag(:li, item_html) do
      if url.present?
        block_given? ? link_to(url, link_html, &block) : link_to(name, url, link_html)
      else
        block_given? ? content_tag(:span, link_html, &block) : content_tag(:span, name, link_html)
      end
    end
  end

  ##
  # Renders a "menu item" to the view if the condition is true.
  # @param condition (Boolean) the condition to be evaluated
  # @param name (String, Symbol)
  # @param url (String, Array)
  # @param options (Hash) a container for options to be passed to menu items and links.
  # @param options[:item_html] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:link_html] (Hash) all options that can be passed to link_to are respected here.
  def menu_item_if(condition, name = nil, url = nil, options = nil, &block)
    menu_item(name, url, options, &block) if condition
  end

  ##
  # Renders a "menu item" to the view if the condition is false.
  # @param condition (Boolean) the condition to be evaluated
  # @param name (String, Symbol)
  # @param url (String, Array)
  # @param options (Hash) a container for options to be passed to menu items and links.
  # @param options[:item_html] (Hash) all options that can be passed to content_tag are respected here.
  # @param options[:link_html] (Hash) all options that can be passed to link_to are respected here.
  def menu_item_unless(condition, name = nil, url = nil, options = nil, &block)
    menu_item_if(!condition, name, url, options, &block)
  end

  private

    def merge_options(value1, value2)
      [value1, value2].flatten.compact
    end
end
