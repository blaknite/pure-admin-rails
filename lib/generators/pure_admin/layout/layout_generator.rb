class PureAdmin::LayoutGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def generate_layout
    copy_file 'admin.html.erb', 'app/views/layouts/admin.html.erb'
    copy_file 'admin.css.scss', 'app/assets/stylesheets/admin.css.scss'
  end
end
