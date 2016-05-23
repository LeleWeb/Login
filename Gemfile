#source "https://rubygems.org"
source "https://ruby.taobao.org"

gem 'rack'
gem 'sinatra', '~> 1.4.7'

gem 'rake', '~> 11.1.2'
gem 'zip', '~> 2.0.2'

gem 'pg', '~> 0.18.4'
gem 'rgeo', '~> 0.5.3'
gem "sinatra-activerecord"
gem 'activerecord', '~> 3.2', :require => 'active_record'
gem 'activesupport', '~> 3.2.22.2'
gem 'composite_primary_keys', '=5.0.13'

gem 'redis', '~> 3.3.0'
gem 'redis-namespace', '~> 1.5.2'
gem "hiredis", "~> 0.4.5"
gem 'dalli', '~> 2.7.6'
gem 'second_level_cache', '~> 1.6.2'

gem 'kgio', '~> 2.10.0'
gem 'racksh', '~> 1.0.0'
gem 'eventmachine', '~> 1.2.0.1'
gem 'em-http-request', '~> 1.1.3'
gem 'hessian2', '1.1.1'
gem 'whenever', :require => false
# gem 'mail'
gem 'savon', '~> 2.11.1'
gem 'redis-objects', '~> 1.2.1'
gem 'pony', '~> 1.11'

group :production do
  gem 'rainbows', '~> 5.0.0'
end

gem 'pry', '~> 0.10.3'
group :development do
  gem 'thin', '~> 1.6.4'
  gem 'sinatra-contrib', '~> 1.4.7'
  # gem 'pry-rails'
  gem 'pry-remote', '~> 0.1.8'
end

group :test do
  gem "rspec", '~> 3.4.0'
  gem "rack-test", '~> 0.6.3'
  gem 'factory_girl', '~> 4.7.0'
  gem 'database_cleaner', '~> 1.5.3'
end