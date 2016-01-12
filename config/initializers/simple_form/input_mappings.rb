##
# Tell SimpleForm to use the following custom input types instead of the defaults.
module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    map_type :email, to: EmailInput
    map_type :tel, to: TelInput
  end
end
