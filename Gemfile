source 'http://rubygems.org'

gem 'rails', '3.2.12'

gem 'pg'

gem 'rubyzip', :require => 'zip/zip'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'compass-rails'
end

gem 'jquery-rails'

group :development do
  gem 'rvm-capistrano'
  gem 'thin'
  gem 'capistrano'
  gem 'annotate', :git => 'http://github.com/ctran/annotate_models.git', :require => false
end

group :test, :development do
  gem 'rspec-rails'
end

group :production do
  gem 'passenger'
  gem 'libv8', '3.3.10.4'
  gem 'therubyracer', '0.10.2'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'pickle'
  gem 'minitest'
  gem 'capybara'
  gem 'turn', :require => false
  gem 'email_spec'
  gem 'launchy'
end

gem 'rgeo'
gem 'rgeo-geojson'
gem 'rgeo-activerecord'
gem 'activerecord-postgis-adapter'

gem 'kaminari'
gem 'devise'
gem 'cancan'
gem 'haml'
gem 'haml-rails'

gem 'formtastic'
gem 'pg_search'

gem "paperclip", "~> 3.0"

gem 'activeadmin'
gem "meta_search",    '>= 1.1.0.pre' # req for activeadmin when rails >= 3.1
