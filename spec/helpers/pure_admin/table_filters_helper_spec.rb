require 'rails_helper'

describe PureAdmin::TableFiltersHelper do
  describe '#table_filters' do
    context 'with a block' do
      subject(:html) { helper.table_filters('http://t.t') { 'block content' } }

      it 'renders a .table-filters form' do
        expect(html).to have_selector('form.table-filters')
      end

      it 'includes the .js-partial-refresh class' do
        expect(html).to have_selector('form.table-filters.js-partial-refresh')
      end

      it 'sets the form action to the given path' do
        expect(html).to have_selector('form.table-filters[action="http://t.t"]')
      end

      it 'sets the form method to get and remote to true' do
        expect(html).to have_selector('form.table-filters[method="get"]')
        expect(html).to have_selector('form.table-filters[data-remote="true"]')
      end

      it 'renders a submit button within the form' do
        expect(html).to have_selector('form.table-filters .filter-submit input[type="submit"]')
      end

      it 'renders the hidden fields for sort order and reverse sort' do
        expect(html).to have_selector('form.table-filters input[type="hidden"][name="sort"]')
        expect(html).to have_selector('form.table-filters input[type="hidden"][name="reverse_order"]')
      end

      it 'renders the block within the .table-filters element' do
        expect(html).to have_selector('form.table-filters', text: 'block content')
      end

      context 'specifically with options' do
        subject(:html) { helper.table_filters('http://t.t', class: 'test') { 'block content' } }

        it 'uses options as html attributes on the .table-filters form' do
          expect(html).to have_selector('form.table-filters.test')
        end

        it 'renders the block within the .table-filters form' do
          expect(html).to have_selector('form.table-filters.test', text: 'block content')
        end
      end

      context 'with a block of nil' do
        it 'returns nil' do
          expect(helper.table_filters('http://t.t', class: 'test') { nil }).to be nil
        end
      end
    end
  end

  describe '#table-filter-item' do
    subject(:html) { helper.table_filter_item(:query) }

    it 'renders a .filter-group element' do
      expect(html).to have_selector('.filter-group')
    end

    it 'renders a .filter-control text input element within .filter-group' do
      expect(html).to have_selector('.filter-group input[type="text"][name="query"].filter-control')
    end

    it 'renders a label with the title as the titleized version of the attribute' do
      expect(html).to have_selector('.filter-group label', text: 'Query')
    end

    context 'with options' do
      context 'with options[:input_html]' do
        it 'uses options as html attributes on the .filter-control input' do
          html = helper.table_filter_item(:query, input_html: { class: 'test' })
          expect(html).to have_selector('.filter-group input[type="text"][name="query"].filter-control.test')
        end
      end

      context 'with options[:label_html]' do
        it 'uses options as html attributes on the label' do
          html = helper.table_filter_item(:query, label_html: { class: 'test' })
          expect(html).to have_selector('.filter-group label.test')
        end
      end

      context 'with options[:label] present' do
        it 'uses this as the text for the label' do
          html = helper.table_filter_item(:query, label: 'A Label')
          expect(html).to have_selector('.filter-group label', text: 'A Label')
        end

        context 'when options[:label] == false' do
          it 'does not render a label' do
            html = helper.table_filter_item(:query, label: false)
            expect(html).to_not have_selector('.filter-group label')
          end
        end
      end

      context 'with options[:type] == :select' do
        subject(:html) { helper.table_filter_item(:query, as: :select) }

        it 'renders a .filter-control select input' do
          expect(html).to have_selector('.filter-group select.filter-control')
        end

        it 'has no options by default' do
          expect(html).to_not have_selector('.filter-group select.filter-control option')
        end

        context 'when given options' do
          it 'renders these options within the select.filter-control' do
            html = helper.table_filter_item(:query, as: :select, options: %w(Yes No))
            expect(html).to have_selector('.filter-group select.filter-control option', text: 'Yes')
            expect(html).to have_selector('.filter-group select.filter-control option', text: 'No')
          end
        end

        context 'when given a default' do
          it 'uses this value to determine which option is selected by default' do
            html = helper.table_filter_item(:query, as: :select, options: %w(Yes No), default: 'No')
            expect(html).to have_selector('.filter-group select.filter-control option[selected]', text: 'No')
          end
        end
      end

      context 'with options[:type] == :date' do
        subject(:html) { helper.table_filter_item(:query, as: :date) }
        it 'renders a .filter-control date input element within .filter-group' do
          selector = '.filter-group input[type="text"][name="query"].filter-control.pure-admin-date'
          expect(html).to have_selector(selector)
        end

        it 'renders a calendar icon addon within .addon-wrapper' do
          expect(html).to have_selector('.filter-group .addon-wrapper span.input-addon.fa-calendar')
        end
      end

      context 'with options[:type] == :active_status' do
        subject(:html) { helper.table_filter_item(:query, as: :active_status) }

        it 'renders a .filter-control select input' do
          expect(html).to have_selector('.filter-group select.filter-control')
        end

        it 'renders All, Active, Inactive options' do
          expect(html).to have_selector('.filter-group select.filter-control option', text: 'All')
          expect(html).to have_selector('.filter-group select.filter-control option', text: 'Active')
          expect(html).to have_selector('.filter-group select.filter-control option', text: 'Inactive')
        end

        it 'sets Active as the default' do
          expect(html).to have_selector('.filter-group select.filter-control option[selected]',
            text: 'Active')
        end
      end

      context 'with options[:type] as anything else' do
        it 'renders a text field' do
          html = helper.table_filter_item(:query, as: :something_else)
          expect(html).to have_selector('.filter-group input[type="text"][name="query"].filter-control')
        end
      end

      context 'when options[:options] is present' do
        it 'renders a select field regardless of the type given' do
          html = helper.table_filter_item(:query, as: :something_else, options: %w(Yes No))
          expect(html).to have_selector('.filter-group select.filter-control')
        end
      end
    end

    context 'with a block' do
      subject(:html) { helper.table_filter_item(:query) { 'block content' } }

      it 'renders a .filter-group element' do
        expect(html).to have_selector('.filter-group')
      end

      it 'renders the block within the .filter-group element' do
        expect(html).to have_selector('.filter-group', text: 'block content')
      end

      it 'renders a label with the title as the titleized version of the attribute' do
        expect(html).to have_selector('.filter-group label', text: 'Query')
      end
    end
  end
end
