#source "https://rubygems.org"
source "https://ruby.taobao.org"

gem 'rack'
gem 'sinatra'

gem 'rake'
gem 'zip'

gem 'pg'
gem 'rgeo'
gem "sinatra-activerecord"
gem 'activerecord', '~> 3.2', :require => 'active_record'
gem 'activerecord-postgis-adapter'
gem 'activesupport'
# need composite primary keys
gem 'composite_primary_keys', '=5.0.13'

gem 'redis'
gem 'redis-namespace'
gem "hiredis", "~> 0.4.5"
gem 'dalli'
gem 'second_level_cache'

gem 'kgio'
gem 'racksh'
gem 'eventmachine'
gem 'em-http-request'
gem 'hessian2', '1.1.1'
gem 'whenever', :require => false
gem 'mail'
gem 'savon'
gem 'redis-objects'

group :production do
  gem 'rainbows'
end

gem 'pry'
group :development do
  gem 'thin'
  gem 'sinatra-contrib'
  # gem 'pry-rails'
  gem 'pry-remote'
end

group :test do
  gem "rspec"
  gem "rack-test"
  gem 'factory_girl'
  gem 'database_cleaner'
end