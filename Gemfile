source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Official Sass port of Bootstrap http://getbootstrap.com/css/#sass
gem 'bootstrap-sass', '~> 3.1.1'

# A Scope & Engine based, clean, powerful, customizable and sophisticated paginator
gem 'kaminari'

# Rails forms made easy.
gem 'simple_form'

# jquery-datatables gem for rails. Provides all the basic DataTables files, and a few extras.
gem 'jquery-datatables-rails', git: 'git://github.com/rweng/jquery-datatables-rails.git'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# jQuery plugin for drop-in fix binded events problem caused by Turbolinks
gem 'jquery-turbolinks'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Better Errors replaces the standard Rails error page with a much better and more useful error page
# binding_of_caller gem added to use Better Errors' advanced features (REPL, local/instance variable inspection, pretty stack frame names)
group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

# rspec-rails is a testing framework for Rails. Read more: https://github.com/rspec/rspec-rails
# factory_girl is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies, and support for multiple factories for the same class, including factory inheritance.
# Load factory_girl_rails in development to get generator hooks
group :development, :test do
  gem 'rspec-rails', '~> 2.99'
  gem 'factory_girl_rails'
end

# Capybara helps test web applications by simulating how a real user would interact with app.
group :test do
  gem 'capybara'
end

# Makes running Rails app easier. Based on the ideas behind 12factor.net
# Required by Heroku to precompile assets in Rails 4
gem 'rails_12factor', group: :production
