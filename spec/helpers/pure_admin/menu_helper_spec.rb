require 'rails_helper'

describe PureAdmin::MenuHelper do
  describe '#menu' do
    context 'with a block' do
      subject(:html) { helper.menu { 'block content' } }

      it 'renders a nav tag' do
        expect(html).to have_selector('nav.pure-menu')
      end

      it 'renders a ul inside the nav tag' do
        expect(html).to have_selector('nav.pure-menu ul.pure-menu-list')
      end

      it 'renders the block within the ul' do
        expect(html).to have_selector('nav.pure-menu ul.pure-menu-list', text: 'block content')
      end

      context 'specifically with options' do
        subject(:html) { helper.menu(menu_html: { data: { options: 'menu' } },
          list_html: { data: { options: 'list' } }) { 'block content' } }

        it 'uses menu_html as html attributes on the nav tag' do
          expect(html).to have_selector('nav.pure-menu[data-options="menu"]')
        end

        it 'uses list_html as html attributes on the ul tag' do
          expect(html).to have_selector('nav.pure-menu ul.pure-menu-list[data-options="list"]')
        end

        it 'renders the block within the ul' do
          expect(html).to have_selector('nav.pure-menu ul.pure-menu-list', text: 'block content')
        end
      end
    end
  end

  describe '#menu-item-and-link' do
    context 'with a name, url, and options' do
      subject(:html) { helper.menu_item_and_link(:name_symbol, 'dest', item_html: { data: { options: 'item' } },
        link_html: { data: { options: 'link' } }) }

      it 'renders an li tag' do
        expect(html).to have_selector('li.pure-menu-item')
      end

      it 'renders an anchor inside the li tag' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link')
      end

      it 'creates a link with the name as the link text' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link', text: /Name Symbol/)
      end

      it 'creates a link with the destination as the href' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link[href="dest"]')
      end

      it 'uses item_html as html attributes for the wrapping li' do
        expect(html).to have_selector('li.pure-menu-item[data-options="item"]')
      end

      it 'uses link_html as html attributes for the anchor' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link[data-options="link"]')
      end

      context 'when the label is given as a string' do
        subject(:html) {
          helper.menu_item_and_link('a Specifically-Cased string', 'dest')
        }

        it 'leaves the letter case as given' do
          expect(html).to have_selector('li.pure-menu-item a.pure-menu-link', text: 'a Specifically-Cased string')
        end
      end
    end

    context 'with a string argument, options, and block' do
      subject(:html) { helper.menu_item_and_link('argument',
        item_html: { data: { options: 'item' } }) { 'block content' } }

      it 'uses the first argument as the destination and creates a link with this as the href' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link[href="argument"]')
      end

      it 'creates a link with the block as the link text' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link', text: 'block content')
      end

      it 'uses options as html attributes for the wrapping li' do
        expect(html).to have_selector('li.pure-menu-item[data-options="item"]')
      end
    end

    context 'with a name and a url' do
      subject(:html) { helper.menu_item_and_link(:name_symbol, 'dest') }

      it 'creates a link with the name as the link text' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link', text: /Name Symbol/)
      end

      it 'creates a link with the destination as the href' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link[href="dest"]')
      end
    end

    context 'with a single string or symbol argument and a block' do
      subject(:html) { helper.menu_item_and_link('single argument') { 'block content' } }

      it 'uses the first argument as the destination and creates a link with this as the href' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link[href="single argument"]')
      end

      it 'creates a link with the block as the link text' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link', text: 'block content')
      end
    end

    context 'when url is blank' do
      subject(:html) { helper.menu_item_and_link('tests', nil) }

      it 'creates a span instead of a link' do
        expect(html).to have_selector('li.pure-menu-item span.pure-menu-link')
      end
    end
  end

  describe '#menu-item' do
    context 'when options[:current] is true' do
      subject(:html) { helper.menu_item(current: true) { 'block content' } }

      it 'marks item as current' do
        expect(html).to have_selector('li.pure-menu-item.current')
      end
    end

    context 'when options[:current] is false' do
      subject(:html) { helper.menu_item(current: false) { 'block content' } }

      it 'does not mark item as current' do
        expect(html).to have_selector('li.pure-menu-item:not(.current)')
      end
    end

    context 'when if condition is true' do
      subject(:html) { helper.menu_item(if: true) { 'block content' } }

      it 'creates an item' do
        expect(html).to have_selector('li.pure-menu-item')
      end
    end

    context 'when if condition is not true' do
      subject(:html) { helper.menu_item(if: false) { 'block content' } }

      it 'does not create an item' do
        expect(html).to_not have_selector('li.pure-menu-item')
      end
    end

    context 'when unless condition is true' do
      subject(:html) { helper.menu_item(unless: true) { 'block content' } }

      it 'does not create an item' do
        expect(html).to_not have_selector('li.pure-menu-item')
      end
    end

    context 'when unless condition is not true' do
      subject(:html) { helper.menu_item(unless: false) { 'block content' } }

      it 'creates an item' do
        expect(html).to have_selector('li.pure-menu-item')
      end
    end
  end
end
