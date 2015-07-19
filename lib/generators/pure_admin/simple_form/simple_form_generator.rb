module PureAdmin
  class SimpleFormGenerator < Rails::Generators::Base
    source_root File.expand_path('../initializers', __FILE__)

    def create_initializer_file
      template 'simple_form.rb', 'config/initializers/simple_form.rb'
    end
  end
end
