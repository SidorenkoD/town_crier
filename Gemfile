source 'https://rubygems.org'
ruby '2.4.1'
gem 'pg'
gem 'rails', '~> 5.1.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'bootstrap-sass', '3.3.6'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'momentjs-rails', '>= 2.9.0'
gem 'puma', '~> 3.7'
gem 'que'
gem 'redis'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'pry-rails'
  gem 'rubocop', require: false
  gem 'selenium-webdriver'
end

gem 'tzinfo-data'
