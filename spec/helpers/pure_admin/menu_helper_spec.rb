require 'rails_helper'

describe PureAdmin::MenuHelper do
  describe '#menu' do
    context 'without a block' do
      it 'raises an error' do
        expect {
          menu
        }.to raise_error(ArgumentError, 'You must supply a block.')
      end
    end

    context 'with a block' do
      subject(:html) { menu { 'link to Google' } }

      it 'renders a main wrapper tag' do
        expect(html).to have_selector('div.pure-menu')
      end

      it 'renders an inner nav tag' do
        expect(html).to have_selector('div.pure-menu nav')
      end

      it 'renders a ul inside the nav tag' do
        expect(html).to have_selector('nav ul.pure-menu-list')
      end

      it 'renders the block within the ul' do
        expect(html).to have_selector('nav ul.pure-menu-list', text: 'link to Google')
      end

      context 'specifically without options' do
        it 'gives the main wrapper tag an id of main-menu' do
          expect(html).to have_selector('.pure-menu#main-menu')
        end

        it 'gives the main wrapper tag a class of pure-menu-horizontal' do
          expect(html).to have_selector('.pure-menu.pure-menu-horizontal')
        end

        it 'gives the main wrapper tag a class of pure-menu-fixed' do
          expect(html).to have_selector('.pure-menu.pure-menu-fixed')
        end

        it 'gives the ul a class of with-animation' do
          expect(html).to have_selector('ul.pure-menu-list.with-animation')
        end

        it 'renders the left/right elements to be used for scrolling' do
          expect(html).
            to have_selector('.pure-menu .fade-left[rel="main-menu-scroll"][data-direction="left"]')

          expect(html).
            to have_selector('.pure-menu .fade-right[rel="main-menu-scroll"][data-direction="right"]')
        end
      end

      context 'specifically with options' do
        subject(:html) { menu(data: { google: true }) { 'link to Google' } }

        it 'uses options as html attributes on the main wrapper tag' do
          expect(html).to have_selector('.pure-menu[data-google="true"]')
        end

        context 'when options[:animate] is passed as false' do
          subject(:html) { menu(animate: false) { 'link to Google' } }

          it 'does not give the ul a class of with-animation' do
            expect(html).to_not have_selector('ul.pure-menu-list.with-animation')
          end
        end

        context 'when options[:horizontal] is passed as false' do
          subject(:html) { menu(horizontal: false) { 'link to Google' } }

          it 'does not give the main wrapper tag a class of pure-menu-horizontal' do
            expect(html).to_not have_selector('.pure-menu.pure-menu-horizontal')
          end
        end

        context 'when options[:fixed] is passed as false' do
          subject(:html) { menu(fixed: false) { 'link to Google' } }

          it 'does not give the main wrapper tag a class of pure-menu-fixed' do
            expect(html).to_not have_selector('.pure-menu.pure-menu-fixed')
          end
        end

        context 'when options[:main_menu] is passed as false' do
          subject(:html) { menu(main_menu: false) { 'link to Google' } }

          it 'does not give the main wrapper tag an id of main-menu' do
            expect(html).to_not have_selector('.pure-menu#main-menu')
          end

          it 'does not render the left/right elements to be used for scrolling' do
            expect(html).to_not have_selector('.pure-menu .fade-left')
            expect(html).to_not have_selector('.pure-menu .fade-right')
          end
        end

        context 'when options[:main_menu] is not false and options[:id] is given' do
          subject(:html) { menu(id: 'my-own-id') { 'link to Google' } }

          it 'uses the given id' do
            expect(html).to have_selector('.pure-menu#my-own-id')
          end

          it 'does not overwrite the default id (#main-menu)' do
            expect(html).to_not have_selector('.pure-menu#main-menu')
          end

          it 'still renders the left/right elements to be used for scrolling' do
            expect(html).to have_selector('.pure-menu .fade-left')
            expect(html).to have_selector('.pure-menu .fade-right')
          end
        end
      end
    end
  end

  describe '#menu-item' do
    context 'with a label, destination, options, and block' do
      it 'raises an argument error' do
        expect {
          helper.menu_item(:label, 'dest', options: true) { 'block' }
        }.to raise_error(ArgumentError)
      end
    end

    context 'with a label, destination, and options' do
      subject(:html) { helper.menu_item(:label_symbol, 'dest', data: { options: true }) }

      it 'creates a link with the label as the link text' do
        expect(html).to have_selector('a.pure-menu-link', text: /Label Symbol/)
      end

      it 'creates a link with the destination as the href' do
        expect(html).to have_selector('a.pure-menu-link[href="dest"]')
      end

      it 'uses options as html attributes for the wrapping li' do
        expect(html).to have_selector('li.pure-menu-item[data-options="true"]')
      end

      context 'when the label is given as a string' do
        subject(:html) {
          helper.menu_item('a Specifically-Cased string', 'dest', data: { options: true })
        }

        it 'leaves the letter case as given' do
          expect(html).to have_selector('a.pure-menu-link', text: 'a Specifically-Cased string')
        end
      end
    end

    context 'with a label, destination, and block' do
      it 'raises an argument error' do
        expect {
          helper.menu_item(:label, 'destination', options: true) { 'block' }
        }.to raise_error(ArgumentError)
      end
    end

    context 'with a string or symbol argument, options, and block' do
      subject(:html) { helper.menu_item(:argument, data: { options: true }) { 'block' } }

      it 'uses the first argument as the destination and creates a link with this as the href' do
        expect(html).to have_selector('a.pure-menu-link[href="argument"]')
      end

      it 'creates a link with the block as the link text' do
        expect(html).to have_selector('a.pure-menu-link', text: /block/)
      end

      it 'uses options as html attributes for the wrapping li' do
        expect(html).to have_selector('li.pure-menu-item[data-options="true"]')
      end
    end

    context 'with a label and a destination' do
      subject(:html) { helper.menu_item(:label_symbol, 'dest') }

      it 'creates a link with the label as the link text' do
        expect(html).to have_selector('a.pure-menu-link', text: /Label Symbol/)
      end

      it 'creates a link with the destination as the href' do
        expect(html).to have_selector('a.pure-menu-link[href="dest"]')
      end
    end

    context 'with a single string or symbol argument and options' do
      # could be label + options or destination + options
      subject(:html) { helper.menu_item('single argument', data: { options: true }) }

      it 'takes the first argument as a label and creates a link with this as the link text' do
        expect(html).to have_selector('a.pure-menu-link', text: /single argument/)
      end

      it 'uses options as html attributes for the wrapping li' do
        expect(html).to have_selector('li.pure-menu-item[data-options="true"]')
      end
    end

    context 'with a single string or symbol argument and a block' do
      subject(:html) { helper.menu_item('single argument') { 'block' } }

      it 'uses the first argument as the destination and creates a link with this as the href' do
        expect(html).to have_selector('a.pure-menu-link[href="single argument"]')
      end

      it 'creates a link with the block as the link text' do
        expect(html).to have_selector('a.pure-menu-link', text: /block/)
      end
    end

    context 'with options and a block' do
      subject(:html) { helper.menu_item(data: { options: true }) { 'block' } }

      it 'detects the options and uses them as html attributes for the wrapping li' do
        expect(html).to have_selector('li.pure-menu-item[data-options="true"]')
      end

      it 'creates a link with the block as the link text' do
        expect(html).to have_selector('a.pure-menu-link', text: /block/)
      end

      it 'creates a link with # as the href' do
        expect(html).to have_selector('a.pure-menu-link[href="#"]')
      end
    end

    context 'with a single sting or symbol argument' do
      subject(:html) { helper.menu_item('only one') }

      it 'uses the first argument as the label and creates a link with this as the link text' do
        expect(html).to have_selector('a.pure-menu-link', text: /only one/)
      end

      it 'creates a link with # as the href' do
        expect(html).to have_selector('a.pure-menu-link[href="#"]')
      end
    end

    context 'with a single hash argument' do
      subject(:html) { helper.menu_item(data: { options: true }) }

      it 'it raises an argument error' do
        expect { html }.to raise_error(ArgumentError)
      end
    end

    context 'with only a block' do
      subject(:html) { helper.menu_item { 'block' } }

      it 'uses the first argument as the label and creates a link with this as the link text' do
        expect(html).to have_selector('a.pure-menu-link', text: /block/)
      end

      it 'creates a link with # as the href' do
        expect(html).to have_selector('a.pure-menu-link[href="#"]')
      end
    end

    context 'when icon is given in the options' do
      subject(:html) { helper.menu_item('destination', icon: :pencil) { 'block' } }

      it 'contains the correct FontAwesome element' do
        expect(html).to have_selector('a.pure-menu-link .fa.fa-pencil')
      end
    end

    context 'when the requested page matches the destination passed in' do
      subject(:html) { helper.menu_item('http://test.host:3000') { 'block' } }

      before do
        helper.request.host = 'test.host:3000'
      end

      it 'applies the class of current to the link' do
        expect(html).to have_selector('a.pure-menu-link.current[href="http://test.host:3000"]')
      end
    end

    context 'when the given label matches the controller_name' do
      subject(:html) { helper.menu_item('tests', 'something-else') }

      before do
        class TestsController < ActionController::Base; end
        helper.controller = TestsController
      end

      it 'applies the class of current to the link' do
        expect(html).to have_selector('a.pure-menu-link.current[href="something-else"]')
      end
    end
  end
end
