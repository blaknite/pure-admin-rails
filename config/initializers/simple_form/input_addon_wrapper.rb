SimpleForm.setup do |config|
  config.wrappers :addon, class: 'pure-control-group pure-u-1',
    error_class: 'control-group-with-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.use :label
    b.wrapper :input_wrapper, tag: :div, class: 'input-wrapper' do |bb|
      bb.wrapper :addon_wrapper, tag: :div, class: 'addon-wrapper' do |bbb|
        bbb.use :input
      end

      bb.use :hint,  wrap_with: { tag: :span, class: 'hint' }
      bb.use :error, wrap_with: { tag: :span, class: 'error' }
    end
  end
end
