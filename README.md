pure-admin
==========

Pure CSS Admin Template for Rails 4. Hopefully I didn't miss anything.

Forms work with SimpleForm, breadcrumbs with crummy.


Installation
============

Add these lines to your Gemfile

```
# Admin theme + dependencies
gem 'pure-admin-rails', github: 'blaknite/pure-admin-rails', branch: 'master'
gem 'pure-css-reset-rails', github: 'blaknite/pure-css-reset-rails', branch: 'master'
gem 'exo2-rails', github: 'blaknite/exo2-rails', branch: 'master'
gem 'crummy', github: 'blaknite/crummy', branch: 'master'
gem 'font-awesome-rails'
gem 'pure-css-rails'
```

Run

```
rails generate pure_admin:layout
rails generate pure_admin:simple_form
```

Then edit ```app/views/layouts/admin.html.erb``` to your liking.

Dependencies
============

Pure CSS, jQuery and waypoints.js.
