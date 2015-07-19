module PureAdmin
  class LayoutGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def generate_layout
      template 'admin.html.erb', 'app/views/layouts/admin.html.erb'
    end
  end
end
