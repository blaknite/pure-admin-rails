$:.push File.expand_path("../lib", __FILE__)

require "pure-admin-rails/version"

Gem::Specification.new do |s|
  s.name        = 'pure-admin-rails'
  s.version     = PureAdmin::Rails::VERSION
  s.date        = '2015-07-19'
  s.authors     = ["Grant Colegate"]
  s.email       = ["blaknite@thelanbox.com.au"]
  s.homepage    = ""
  s.summary     = "A simple admin theme for Pure CSS"
  s.description = "A simple admin theme for Pure CSS"

  s.files = Dir["{app,lib}/**/*", "LICENSE", "README.md"]

  s.add_dependency "jquery-rails"
  s.add_dependency "font-awesome-rails"
  s.add_dependency "pure-css-rails"
  s.add_dependency "pure-css-reset-rails"
  s.add_dependency "exo2-rails"
  s.add_dependency "crumpet"
  s.add_dependency "simple_form"
  s.add_dependency 'select2-rails'

  s.add_development_dependency 'bundler', '>= 1.12.5'
  s.add_development_dependency 'rake', '~> 11.3.0'
  s.add_development_dependency 'rspec', '~> 3.5.0'
end
