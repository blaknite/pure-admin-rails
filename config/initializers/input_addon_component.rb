##
# Enables the rendering of prefixes and suffixes to the input field.
# @see https://github.com/plataformatec/simple_form/wiki/Adding-custom-components
module SimpleForm::Components::InputAddon
  ##
  # If the prefix attribute is present, this method returns a label for the current attribute with
  # the contents of the attribute. If not present, returns nil.
  # @return (String, nil)
  def prefix
    @builder.label(attribute_name, options[:prefix].to_s, class: 'addon-label') if options[:prefix]
  end

  ##
  # Used by SimpleForm to determine whether to show inputs that are specified as optional.
  # @note see the SimpleForm initialiser for this specification
  # @return (Boolean)
  def has_prefix?
    options[:prefix].present?
  end

  ##
  # If the suffix attribute is present, this method returns a label for the current attribute with
  # the contents of the attribute. If not present, returns nil.
  # @return (String, nil)
  def suffix
    @builder.label(attribute_name, options[:suffix].to_s, class: 'addon-label') if options[:suffix]
  end

  ##
  # Used by SimpleForm to determine whether to show inputs that are specified as optional.
  # @note see the SimpleForm initialiser for this specification
  # @return (Boolean)
  def has_suffix?
    options[:suffix].present?
  end
end

##
# Tell SimpleForm to include the above InputComponent class.
SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::InputAddon)
