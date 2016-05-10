##
# Helper methods for dropdown functionality.
#
# The recommended way of using this helper is
#
#   dropdown 'Tools', class: ''do
#     dropdown_item :name, 'url', item_html: { class: '' }
#   end
#
# @note this helper depends {PureAdmin::MenuHelper}
module PureAdmin::DropdownHelper
  ##
  # Renders a dropdown to the view.
  # @param name (String) the name to display on the main dropdown link.
  # @param options (Hash) all options that can be passed to the menu_helper as menu_html are
  # respected here.
  # @yield The contents for the dropdown
  def dropdown(name, options = {}, &block)
    opts = {}
    opts[:menu_html] = options
    opts[:menu_html][:class] = merge_html_classes('dropdown pure-menu-horizontal', opts[:class])

    content = capture(&block)
    content = content_tag(:ul, content, class: 'pure-menu-children')
    content = content_tag(:li, link_to(name, '', class: 'pure-menu-link') + content,
      class: 'pure-menu-item pure-menu-has-children')

    menu(opts) { content }
  end

  ##
  # Renders a dropdown item to the view.
  # @param name (String) the name to pass to PureAdmin::MenuHelper.menu_item_and_link
  # @param name (url) the url to pass to PureAdmin::MenuHelper.menu_item_and_link
  # @param name (Hash) the options to pass to PureAdmin::MenuHelper.menu_item_and_link
  # @yield the content to pass to PureAdmin::MenuHelper.menu_item_and_link
  def dropdown_item(name = nil, url = nil, options = nil, &block)
    menu_item_and_link(name, url, options, &block)
  end
end
