require 'rails_helper'

describe PureAdmin::ApplicationHelper do
  pending '#merge_html_classes'

  describe '#boolean_label' do
    context 'when the value is nil' do
      it 'returns nil' do
        expect(helper.boolean_label(nil)).to be_nil
      end
    end

    context 'when the value is "truthy"' do
      let(:html) { helper.boolean_label(true) }

      it 'returns HTML for a tag class' do
        expect(html).to have_selector('.tag.tag-green')
      end
      it 'returns HTML for a check icon' do
        expect(html).to have_selector('.fa.fa-check')
      end
    end

    context 'when the value is not "truthy"' do
      let(:html) { helper.boolean_label(false) }

      it 'returns HTML for a tag class' do
        expect(html).to have_selector('.tag')
      end
      it 'returns HTML for a cross icon' do
        expect(html).to have_selector('.fa.fa-times')
      end
    end
  end
end
