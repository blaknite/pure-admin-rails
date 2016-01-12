require 'rails_helper'

describe PureAdmin::DetailsPanelHelper do
  describe '#details_panel' do
    context 'with a block' do
      subject(:html) { helper.details_panel { 'block content' } }

      it 'renders a .details-panel element' do
        expect(html).to have_selector('div.details-panel')
      end

      it 'renders a .details-panel-body element inside the .details-panel element' do
        expect(html).to have_selector('div.details-panel div.details-panel-body')
      end

      it 'renders the block within the .details-panel-body element' do
        expect(html).to have_selector('div.details-panel div.details-panel-body', text: 'block content')
      end

      it 'does not render a title' do
        expect(html).to_not have_selector('div.details-panel div.details-panel-title h4')
      end

      context 'specifically with options' do
        subject(:html) {
          helper.details_panel(panel_html: { data: { options: 'panel' } },
            body_html: { data: { options: 'body' } }) { 'block content' }
        }

        it 'uses panel_html as html attributes on the .details-panel element' do
          expect(html).to have_selector('div.details-panel[data-options="panel"]')
        end

        it 'uses body_html as html attributes on the .details-panel-body element' do
          expect(html).to have_selector('div.details-panel div.details-panel-body[data-options="body"]')
        end

        it 'renders the block within the .details-panel-body element' do
          expect(html).to have_selector('div.details-panel div.details-panel-body', text: 'block content')
        end
      end
    end
  end

  describe '#details_panel_item' do
    context 'with a label, value, and options' do
      subject(:html) { helper.details_panel_item(:label_symbol, 'value', data: { options: true }) }

      it 'renders a .details-item element' do
        expect(html).to have_selector('div.details-item')
      end

      it 'renders a titleized label inside the .details-item element' do
        expect(html).to have_selector('div.details-item label', text: 'Label Symbol')
      end

      it 'renders the value inside the .details-item element' do
        expect(html).to have_selector('div.details-item', text: /value/)
      end

      it 'uses options as html attributes' do
        expect(html).to have_selector('div.details-item[data-options="true"]')
      end

      context 'when the label is given as a string' do
        subject(:html) {
          helper.details_panel_item('a Specifically-Cased string', 'value', data: { options: true })
        }

        it 'leaves the letter case as given' do
          expect(html).to have_selector('div.details-item label', text: 'a Specifically-Cased string')
        end
      end
    end

    context 'with a string argument, options, and block' do
      subject(:html) { helper.details_panel_item('argument', data: { options: true }) { 'block' } }

      it 'uses the first argument as a label' do
        expect(html).to have_selector('div.details-item label', text: 'argument')
      end

      it 'uses the supplied block' do
        expect(html).to have_selector('div.details-item', text: /block/)
      end

      it 'detects the options and uses them as html attributes' do
        expect(html).to have_selector('div.details-item[data-options="true"]')
      end
    end

    context 'with a label and a value' do
      subject(:html) { helper.details_panel_item(:label_symbol, 'value') }

      it 'contains the label' do
        expect(html).to have_selector('div.details-item label', text: /Label Symbol/)
      end

      it 'contains the value' do
        expect(html).to have_selector('div.details-item', text: /value/)
      end
    end

    context 'with a single string or symbol argument and a block' do
      subject(:html) { helper.details_panel_item('single argument') { 'block' } }

      it 'takes the argument as a label' do
        expect(html).to have_selector('div.details-item label', text: 'single argument')
      end

      it 'uses the supplied block' do
        expect(html).to have_selector('div.details-item', text: /block/)
      end
    end

    context 'with a single sting or symbol argument' do
      subject(:html) { helper.details_panel_item('only one') }

      it 'takes the argument as a label' do
        expect(html).to have_selector('div.details-item label', text: 'only one')
      end
    end

    context 'with only a block' do
      subject(:html) { helper.details_panel_item { 'block' } }

      it 'uses the supplied block' do
        expect(html).to have_selector('div.details-item', text: /block/)
      end

      it 'produces a blank label' do
        expect(html).to have_selector('div.details-item label', text: '')
      end
    end
  end

  describe '#details_panel_controls' do
    subject(:html) { helper.details_panel_controls { 'pear' } }

    it { is_expected.to have_selector('div.details-panel-controls') }

    it 'uses the supplied block' do
      expect(html).to have_selector('.details-panel-controls', text: /pear/)
    end

    context 'but with options' do
      subject(:html) { helper.details_panel_controls(data: { options: true }) { 'pear' } }

      it 'uses the options as html attributes' do
        expect(html).to have_selector('div.details-panel-controls[data-options="true"]')
      end
    end
  end
end
