require 'rails_helper'

describe PureAdmin::MenuHelper do
  describe '#menu' do
    context 'with a block' do
      subject(:html) { menu { 'block content' } }

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
        subject(:html) { menu(menu_options: { data: { options: 'menu' } },
          list_options: { data: { options: 'list' } }) { 'block content' } }

        it 'uses menu_options as html attributes on the nav tag' do
          expect(html).to have_selector('nav.pure-menu[data-options="menu"]')
        end

        it 'uses list_options as html attributes on the ul tag' do
          expect(html).to have_selector('nav.pure-menu ul.pure-menu-list[data-options="list"]')
        end

        it 'renders the block within the ul' do
          expect(html).to have_selector('nav.pure-menu ul.pure-menu-list', text: 'block content')
        end
      end
    end
  end

  describe '#menu-item' do
    context 'with a name, url, and options' do
      subject(:html) { helper.menu_item(:name_symbol, 'dest', item_options: { data: { options: 'item' } },
        link_options: { data: { options: 'link' } }) }

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

      it 'uses item_options as html attributes for the wrapping li' do
        expect(html).to have_selector('li.pure-menu-item[data-options="item"]')
      end

      it 'uses link_options as html attributes for the anchor' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link[data-options="link"]')
      end

      context 'when the label is given as a string' do
        subject(:html) {
          helper.menu_item('a Specifically-Cased string', 'dest')
        }

        it 'leaves the letter case as given' do
          expect(html).to have_selector('li.pure-menu-item a.pure-menu-link', text: 'a Specifically-Cased string')
        end
      end
    end

    context 'with a string argument, options, and block' do
      subject(:html) { helper.menu_item('argument',
        item_options: { data: { options: 'item' } }) { 'block content' } }

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
      subject(:html) { helper.menu_item(:name_symbol, 'dest') }

      it 'creates a link with the name as the link text' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link', text: /Name Symbol/)
      end

      it 'creates a link with the destination as the href' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link[href="dest"]')
      end
    end

    context 'with a single string or symbol argument and a block' do
      subject(:html) { helper.menu_item('single argument') { 'block content' } }

      it 'uses the first argument as the destination and creates a link with this as the href' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link[href="single argument"]')
      end

      it 'creates a link with the block as the link text' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link', text: 'block content')
      end
    end

    context 'when the requested page matches the destination passed in' do
      subject(:html) { helper.menu_item('http://test.host:3000') { 'block content' } }

      before do
        helper.request.host = 'test.host:3000'
      end

      it 'applies the class of current to the menu item' do
        expect(html).to have_selector('li.pure-menu-item.current')
      end
    end

    context 'when the given label matches the controller_name' do
      subject(:html) { helper.menu_item('tests', 'something-else') }

      before do
        class TestsController < ActionController::Base; end
        helper.controller = TestsController
      end

      it 'applies the class of current to the menu item' do
        expect(html).to have_selector('li.pure-menu-item.current')
      end
    end

    context 'when url is blank' do
      subject(:html) { helper.menu_item('tests', nil) }

      it 'creates a span instead of a link' do
        expect(html).to have_selector('li.pure-menu-item span.pure-menu-link')
      end
    end
  end

  describe '#menu-item-if' do
    context 'when condition is true' do
      subject(:html) { helper.menu_item_if(true, 'name', 'url') }

      it 'creates a link' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link')
      end
    end

    context 'when condition is not true' do
      subject(:html) { helper.menu_item_if(false, 'name', 'url') }

      it 'does not create a link' do
        expect(html).to_not have_selector('li.pure-menu-item a.pure-menu-link')
      end
    end
  end

  describe '#menu-item-unless' do
    context 'when condition is true' do
      subject(:html) { helper.menu_item_unless(true, 'name', 'url') }

      it 'does not create a link' do
        expect(html).to_not have_selector('li.pure-menu-item a.pure-menu-link')
      end
    end

    context 'when condition is not true' do
      subject(:html) { helper.menu_item_unless(false, 'name', 'url') }

      it 'creates a link' do
        expect(html).to have_selector('li.pure-menu-item a.pure-menu-link')
      end
    end
  end
end
