require 'rails_helper'

describe PureAdmin::ApplicationHelper do
  describe '#portlet' do
    context 'without a title' do
      subject(:html) { portlet { 'banana' } }

      it { is_expected.to have_selector('div.portlet') }

      it { is_expected.to_not have_selector('.portlet-title') }
      it { is_expected.to_not have_selector('h4') }

      it 'uses the supplied body text' do
        expect(html).to have_selector('.portlet .portlet-body', text: /banana/)
      end

      context 'but with options' do
        subject(:html) { portlet(class: 'tricky') { 'banana' } }

        it 'does not build a portlet-title' do
          expect(html).to_not have_selector('.portlet .portlet-title')
        end
        it 'extracts options from the first parameter' do
          expect(html).to have_selector('div.portlet.tricky')
        end
      end
    end

    context 'with a title' do
      context 'when a block is given' do
        subject(:html) { portlet('apples', class: 'classy', data: { whizz: 'pop' }) { 'banana' } }

        it 'uses options as html attributes' do
          expect(html).to have_selector('div.portlet[data-whizz="pop"]')
        end

        it 'merges a supplied class with the default' do
          expect(html).to have_selector('div.portlet.classy')
        end

        it 'includes an h4 title' do
          expect(html).to have_selector('.portlet .portlet-title h4', text: 'apples')
        end

        it 'uses the supplied body text' do
          expect(html).to have_selector('.portlet .portlet-body', text: /banana/)
        end

        it { is_expected.to_not have_selector('.portlet-indicator') }
        it { is_expected.to have_selector('.portlet[data-closable=false]') }

        context 'when closable' do
          context 'when expand is passed as true' do
            subject(:html) { portlet('apples', expand: true) { 'banana' } }

            it { is_expected.to have_selector('.portlet-indicator') }
            it { is_expected.to have_selector('.portlet[data-closable=true]') }
            it { is_expected.to have_selector('.portlet.expanded') }
            it { is_expected.to have_selector('.portlet[data-expand=true]') }
          end

          context 'when expand is passed as false' do
            subject(:html) { portlet('apples', expand: false) { 'banana' } }

            it { is_expected.to have_selector('.portlet-indicator') }
            it { is_expected.to have_selector('.portlet[data-closable=true]') }
            it { is_expected.to_not have_selector('.portlet.expanded') }
            it { is_expected.to_not have_selector('.portlet[data-expand=true]') }
          end
        end

        context 'when an icon is given' do
          subject(:html) { portlet('apples', icon: :pencil) { 'banana' } }

          it 'contains the correct FontAwesome element' do
            expect(html).to have_selector('.portlet-title h4 .fa.fa-fw.fa-pencil')
          end
        end
      end

      context 'when the source attribute is passed in' do
        context 'when expand is passed as true' do
          subject(:html) { portlet('apples', source: 'google.com', expand: true) }

          it { is_expected.to have_selector('.portlet-indicator') }
          it { is_expected.to have_selector('.portlet[data-closable=true]') }
          it { is_expected.to have_selector('.portlet.expanded') }
          it { is_expected.to have_selector('.portlet[data-expand=true]') }

          it { is_expected.to have_selector('.portlet[data-source="google.com"]') }
        end

        context 'when expand is passed as false' do
          subject(:html) { portlet('apples', source: 'google.com', expand: false) }

          it { is_expected.to have_selector('.portlet-indicator') }
          it { is_expected.to have_selector('.portlet[data-closable=true]') }
          it { is_expected.to_not have_selector('.portlet.expanded') }
          it { is_expected.to_not have_selector('.portlet[data-expand=true]') }

          it { is_expected.to have_selector('.portlet[data-source="google.com"]') }
        end

        context 'when an icon is given' do
          subject(:html) { portlet('apples', source: 'google.com', icon: :pencil) }

          it 'contains the correct FontAwesome element' do
            expect(html).to have_selector('.portlet-title h4 .fa.fa-fw.fa-pencil')
          end
        end
      end
    end
  end
end
