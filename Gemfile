source "https://rubygems.org"
ruby "2.5.0"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

group :production, :development, :test do
  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
  gem "rails", "~> 5.1.5", require: false
  # Use sqlite3 as the database for Active Record
  # sqlite is disabled here because we want to use it only for development.
  # gem "sqlite3", require: false
  # Use Puma as the app server
  gem "puma", "~> 3.7", require: false
  # Use SCSS for stylesheets
  gem "sass-rails", "~> 5.0", require: false
  # Use Uglifier as compressor for JavaScript assets
  gem "uglifier", ">= 1.3.0", require: false
  # See https://github.com/rails/execjs#readme for more supported runtimes
  # gem 'therubyracer', platforms: :ruby

  # Use CoffeeScript for .coffee assets and views
  gem "coffee-rails", "~> 4.2", require: false
  # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
  gem "turbolinks", "~> 5", require: true
  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  gem "jbuilder", "~> 2.5", require: false
  # Use Redis adapter to run Action Cable in production
  # gem 'redis', '~> 4.0'
  # Use ActiveModel has_secure_password
  # gem 'bcrypt', '~> 3.1.7'

  # Use Capistrano for deployment
  # gem 'capistrano-rails', group: :development

  ##############################
  # Place all added gems below #
  ##############################

  gem "activeadmin"
  gem "chartkick"
  gem "colorize"
  gem "csv"
  gem "devise"
  gem "haml"
  gem "seedbank"
end

group :production do
  ##############################
  # Place all added gems below #
  ##############################

  gem "pg"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", "~> 2.13", require: false
  gem "selenium-webdriver", require: false

  ##############################
  # Place all added gems below #
  ##############################

  gem "awesome_print", require: true
  gem "cucumber", require: false
  gem "cucumber_lint", require: false
  gem "pry-nav", require: true
  gem "pry-rails", require: true
  gem "rubocop", "~> 0.54.0", require: false
  gem "sqlite3", require: false
end

group :test do
  gem "cucumber-rails", require: false
  # database_cleaner is not required, but highly recommended
  gem "database_cleaner"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # Spring is disabled because it sometimes causes rails console to hang, without indicating
  # that spring is the problem. It also currently does not speed up app loading significantly.
  # gem "spring"
  # gem "spring-watcher-listen", "~> 2.0.0"

  ##############################
  # Place all added gems below #
  ##############################

  gem "debase", require: false
  gem "haml_lint", require: false
  gem "mdl", require: false
  gem "rails_db"
  gem "ruby-debug-ide", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
