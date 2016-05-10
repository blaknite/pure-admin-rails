require 'rails_helper'

describe PureAdmin::PortletHelper do
  describe '#portlet' do
    context 'when a block is given' do
      subject(:html) {
        helper.portlet('apples', portlet_html: { class: 'classy', data: { whizz: 'pop' } }) { 'banana' }
      }

      it 'uses options as html attributes' do
        expect(html).to have_selector('div.portlet[data-whizz="pop"]')
      end

      it 'merges a supplied class with the default' do
        expect(html).to have_selector('div.portlet.classy')
      end

      it 'includes an h4 title' do
        expect(html).to have_selector('.portlet .portlet-heading h4', text: 'apples')
      end

      it 'uses the supplied body text' do
        expect(html).to have_selector('.portlet .portlet-body', text: /banana/)
      end

      it { is_expected.to_not have_selector('.portlet-indicator') }
      it { is_expected.to have_selector('.portlet[data-closable=false]') }

      context 'when closable' do
        context 'when expand is passed as true' do
          subject(:html) { helper.portlet('apples', expand: true) { 'banana' } }

          it { is_expected.to have_selector('.portlet-indicator') }
          it { is_expected.to have_selector('.portlet[data-closable=true]') }
          it { is_expected.to have_selector('.portlet.expanded') }
          it { is_expected.to have_selector('.portlet[data-expand=true]') }
        end

        context 'when expand is passed as false' do
          subject(:html) { helper.portlet('apples', expand: false) { 'banana' } }

          it { is_expected.to have_selector('.portlet-indicator') }
          it { is_expected.to have_selector('.portlet[data-closable=true]') }
          it { is_expected.to_not have_selector('.portlet.expanded') }
          it { is_expected.to_not have_selector('.portlet[data-expand=true]') }
        end
      end

      context 'when an icon is given' do
        subject(:html) { helper.portlet('apples', icon: :pencil) { 'banana' } }

        it 'contains the correct FontAwesome element' do
          expect(html).to have_selector('.portlet-heading-icon.fa.fa-fw.fa-pencil')
        end
      end
    end

    context 'when the source attribute is passed in' do
      context 'when expand is passed as true' do
        subject(:html) { helper.portlet('apples', source: 'google.com', expand: true) }

        it { is_expected.to have_selector('.portlet-indicator') }
        it { is_expected.to have_selector('.portlet[data-closable=true]') }
        it { is_expected.to have_selector('.portlet.expanded') }
        it { is_expected.to have_selector('.portlet[data-expand=true]') }

        it { is_expected.to have_selector('.portlet[data-source="google.com"]') }
      end

      context 'when expand is passed as false' do
        subject(:html) { helper.portlet('apples', source: 'google.com', expand: false) }

        it { is_expected.to have_selector('.portlet-indicator') }
        it { is_expected.to have_selector('.portlet[data-closable=true]') }
        it { is_expected.to_not have_selector('.portlet.expanded') }
        it { is_expected.to_not have_selector('.portlet[data-expand=true]') }

        it { is_expected.to have_selector('.portlet[data-source="google.com"]') }
      end

      context 'when an icon is given' do
        subject(:html) { helper.portlet('apples', source: 'google.com', icon: :pencil) }

        it 'contains the correct FontAwesome element' do
          expect(html).to have_selector('.portlet-heading-icon.fa.fa-fw.fa-pencil')
        end
      end
    end

    context 'when heading_html is passed in' do
      it 'adds the class to the heading' do
        expect(helper.portlet('Peaches', heading_html: { class: 'fuzzy' })).to \
          have_selector('.portlet-heading.fuzzy')
      end

      it 'adds other attributes (ie: data)' do
        expect(helper.portlet('Peaches', heading_html: { data: { pits: true } })).to \
          have_selector('.portlet-heading[data-pits]')
      end
    end

    context 'when body_html is passed in' do
      it 'adds the class to the body' do
        expect(helper.portlet('Peaches', body_html: { class: 'fuzzy' })).to \
          have_selector('.portlet-body.fuzzy')
      end

      it 'adds other attributes (ie: data)' do
        expect(helper.portlet('Peaches', body_html: { data: { pits: true } })).to \
          have_selector('.portlet-body[data-pits]')
      end
    end

    context 'when controls are passed in' do
      context 'when a single control is passed' do
        it 'includes the controls within the .portlet-controls class' do
          expect(helper.portlet('Pineapple', controls: link_to('Test', 'http://test.test'))).to \
            have_selector('.portlet-heading .portlet-controls .portlet-control-item', text: 'Test')
        end
      end

      context 'when an array of controls are passed' do
        it 'includes each controls within the .portlet-controls class' do
          controls = [link_to('Test', 'http://test.test'), link_to('Spec', 'http://spec.spec')]
          html = helper.portlet('Pineapple', controls: controls);
          expect(html).to have_selector('.portlet-heading .portlet-controls .portlet-control-item',
            text: 'Test')
          expect(html).to have_selector('.portlet-heading .portlet-controls .portlet-control-item',
            text: 'Test')
        end
      end
    end
  end
end
