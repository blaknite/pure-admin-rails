require 'rails_helper'

describe PureAdmin::ButtonHelper do
  describe '#save_button' do
    subject(:html) { helper.save_button }

    it 'renders a submit button' do
      expect(html).to have_selector('button[type="submit"].pure-button.pure-button-primary',
        text: 'Save')
    end

    it 'renders a tick icon' do
      expect(html).to have_selector('button[type="submit"] i.fa-check')
    end

    it 'passes any options to the button_tag helper' do
      expect(helper.save_button(class: 'test')).to have_selector('button[type="submit"].pure-button.test')
    end
  end

  describe '#edit_button' do
    subject(:html) { helper.edit_button('http://t.t') }

    it 'renders an edit button' do
      expect(html).to have_selector('a[href="http://t.t"].pure-button.pure-button-primary', text: 'Edit')
    end

    it 'renders a pencil icon' do
      expect(html).to have_selector('a[href="http://t.t"] i.fa-pencil')
    end

    it 'passes any options to the link_to helper' do
      expect(helper.edit_button('http://t.t', class: 'test')).to have_selector('a[href="http://t.t"].test')
    end
  end

  describe '#back_button' do
    subject(:html) { helper.back_button('http://t.t') }

    it 'renders an back button' do
      expect(html).to have_selector('a[href="http://t.t"].pure-button', text: 'Back')
    end

    it 'passes any options to the link_to helper' do
      expect(helper.back_button('http://t.t', class: 'test')).to have_selector('a[href="http://t.t"].test')
    end

    context 'when not given a path' do
      it 'uses the Rails :back method' do
        expect(helper.back_button).to have_selector('a[href="javascript:history.back()"]', text: 'Back')
      end
    end
  end

  describe '#cancel_button' do
    subject(:html) { helper.cancel_button('http://t.t') }

    it 'renders an cancel button' do
      expect(html).to have_selector('a[href="http://t.t"].pure-button', text: 'Cancel')
    end

    it 'renders a ban icon' do
      expect(html).to have_selector('a[href="http://t.t"] i.fa-ban')
    end

    it 'passes any options to the link_to helper' do
      expect(helper.cancel_button('http://t.t', class: 'test')).to have_selector('a[href="http://t.t"].test')
    end

    context 'when not given a path' do
      it 'uses the Rails :back method' do
        expect(helper.cancel_button).to have_selector('a[href="javascript:history.back()"]', text: 'Cancel')
      end
    end
  end

  describe '#delete_button' do
    subject(:html) { helper.delete_button('http://t.t') }

    it 'renders a delete button' do
      expect(html).to have_selector('a[href="http://t.t"][rel="modal"][modal="confirm"]' \
        '[data-modal-request-method="delete"].pure-button.button-red', text: 'Delete')
    end

    it 'renders a trash icon' do
      expect(html).to have_selector('a[href="http://t.t"] i.fa-trash-o')
    end

    it 'passes any options to the link_to helper' do
      expect(helper.delete_button('http://t.t', class: 'test')).to have_selector('a[href="http://t.t"].test')
    end

    context 'when passed a label' do
      it 'uses this as the label to the anchor tag' do
        html = helper.delete_button('http://t.t', label: 'Test')
        expect(html).to have_selector('a[href="http://t.t"][rel="modal"][modal="confirm"]' \
          '[data-modal-request-method="delete"].pure-button.button-red', text: 'Test')
      end
    end

    context 'when passed an icon' do
      it 'uses this as the icon' do
        html = helper.delete_button('http://t.t', icon: 'fa-calendar')
        expect(html).to have_selector('a[href="http://t.t"] i.fa-calendar')
      end
    end
  end
end
