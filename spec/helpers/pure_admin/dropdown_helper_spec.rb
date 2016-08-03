require 'rails_helper'

describe PureAdmin::DropdownHelper do
  describe '#dropdown' do
    context 'with a block' do
      subject(:html) { helper.dropdown('Tools') { 'block content' } }

      it 'renders a nav tag' do
        expect(html).to have_selector('nav.pure-menu.dropdown.pure-menu-horizontal')
      end

      it 'renders a child list inside the nav tag' do
        expect(html).to have_selector('nav.pure-menu ul.pure-menu-list li.pure-menu-has-children')
      end

      it 'renders the block within the ul' do
        expect(html).to have_selector('nav.pure-menu ul.pure-menu-list', text: 'block content')
      end

      context 'specifically with options' do
        subject(:html) { helper.dropdown('Tools', data: { options: 'menu' }) { 'block content' } }

        it 'uses menu_html as html attributes on the nav tag' do
          expect(html).to have_selector('nav.pure-menu.dropdown[data-options="menu"]')
        end

        it 'renders the block within the ul' do
          expect(html).to have_selector('nav.pure-menu ul.pure-menu-list', text: 'block content')
        end
      end
    end
  end

  describe '#dropdown_item' do
    it 'calls #menu_item_and_link with the appropriate arguments' do
      expect_any_instance_of(PureAdmin::MenuHelper).to receive(:menu_item_and_link).
        with('name', 'url', options: true)
      helper.dropdown_item('name', 'url', options: true)
    end
  end
end
