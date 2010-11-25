gem "haml-rails", ">= 0.3.1"
gem 'inherited_resources', '>=1.1.2'
gem 'will_paginate', '>=3.0.pre2'
gem 'devise', '>=1.1.2'
gem "formtastic", '>=1.1.0'
gem 'friendly_id', '~>3.0'
gem 'rails3-generators', :git => "git://github.com/indirect/rails3-generators.git"
gem 'jquery-rails'

gem "capybara", ">= 0.3.9", :group => [:test, :cucumber]
gem "cucumber-rails", ">= 0.3.2", :group => [:test, :cucumber]
gem "database_cleaner", ">= 0.5.2", :group => [:test, :cucumber]
gem "factory_girl_rails", ">= 1.0.0", :group => [:test, :cucumber]
gem "factory_girl_generator", ">= 0.0.1", :group => [:test, :cucumber, :development]
gem "launchy", ">= 0.3.7", :group => [:test, :cucumber]
gem "rspec-rails", ">= 2.0.0", :group => [:test, :cucumber]
gem "spork", ">= 0.8.4", :group => [:test, :cucumber]

application  <<-GENERATORS 
  config.generators do |g|
    g.template_engine :haml
    g.test_framework  :rspec, :fixture => true, :views => false
    g.integration_tool :rspec, :fixture => true, :views => true
    g.fixture_replacement :factory_girl, :dir => "spec/support/factories"
  end
  config.i18n.load_path
  config.i18n.default_locale = :pt_BR
  config.time_zone = 'Brasilia'
GENERATORS

gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery.min.js rails.js)'
    
layout = <<-LAYOUT
!!!
%html
  %head
    %title #{app_name.humanize}
    = stylesheet_link_tag :all
    = csrf_meta_tag
  %body
    = yield
    = javascript_include_tag :defaults
LAYOUT

remove_file "app/views/layouts/application.html.erb"
create_file "app/views/layouts/application.html.haml", layout

admin = <<-ADMIN
%html
  %head
    %title #{app_name.humanize}
    = stylesheet_link_tag :all
    = csrf_meta_tag
  %body
    = yield
    = javascript_include_tag :backend
ADMIN

create_file "app/views/layouts/admin.html.haml", admin

run "rm -Rf README public/index.html test"
run "gem install bundler"
run "bundle install"
generate "rspec:install"
generate "cucumber:install --capybara --rspec --spork"
generate "jquery:install"
generate "friendly_id"
generate "formtastic:install"
generate "devise:install"
generate "devise User"

git :init
git :add => '.'
git :commit => '-am "Initial commit"'
