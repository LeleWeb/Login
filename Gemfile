source "https://ruby.taobao.org"
gem 'rack'
gem 'sinatra'
gem 'rake'
gem 'activerecord', '~> 3.2', :require => 'active_record'
gem 'activesupport'
gem "sinatra-activerecord"
gem 'kgio'
gem 'racksh'
gem 'eventmachine'
gem 'em-http-request'

gem 'pg'
gem 'rgeo'
gem 'activerecord-postgis-adapter'

gem 'redis'
gem 'redis-namespace'
gem "hiredis", "~> 0.4.5"
gem 'dalli'
gem 'second_level_cache'
gem 'redis-objects'
gem "nokogiri", ">= 1.6.7.rc"

group :production do
  gem 'rainbows'
end
gem 'pry'
group :development do
  gem 'thin'
  gem 'sinatra-contrib'
end

group :test do
  gem "rspec"
  gem "rack-test"
  gem 'factory_girl'
  gem 'database_cleaner'
end