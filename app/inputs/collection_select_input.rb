##
# Overrides SimpleForm's default CollectionSelectInput to add a class.
# This class is then used to initialise Select2 on all collection select inputs.
class CollectionSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input_html_classes
    super.push('pure-admin-select')
  end

  def input_html_options
    super.deep_merge(
      style: 'width: 100%;',
      data: {
        tags: options[:create_when_no_match] || false
      }
    )
  end
end
