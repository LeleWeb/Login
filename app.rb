# encoding: UTF-8

USE_MEM_CACHE = true


ENV['RACK_ENV'] ||= "development"
ENV['BUNDLE_GEMFILE'] ||= ::File.expand_path('../Gemfile', __FILE__)
require 'bundler/setup' if ::File.exists?(ENV['BUNDLE_GEMFILE'])
::Bundler.require(:default, ENV['RACK_ENV'].to_sym)
ENV['APP_ROOT'] ||= ::File.expand_path(::File.dirname(__FILE__))
ENV['LOG_PATH'] ||= ::File.expand_path(::File.join(ENV['APP_ROOT'],'log'))

require 'sinatra'

if development?
  puts ">> Development mode will reload change!!"
  use Rack::Reloader, 0
end

APP_CONFIG_PATH  = ::File.expand_path("../config", __FILE__) + '/app_config.yml'
APP_CONFIG = ::YAML.load_file(APP_CONFIG_PATH)[ENV["RACK_ENV"]] if File.exists?(APP_CONFIG_PATH)
AUTOLOAD_PATHS = %w{config/initializers models controllers}

require 'logger'
::Dir.mkdir(ENV['LOG_PATH']) unless ::File.exist?(ENV['LOG_PATH'])
class ::Logger; alias_method :write, :<<; end
log_file = "#{ENV['LOG_PATH']}/#{ENV["RACK_ENV"]}.log"
task_log_file = "#{ENV['LOG_PATH']}/task_#{ENV["RACK_ENV"]}.log"
case ENV["RACK_ENV"]
when "production" then
  $common_logger = ::Logger.new(log_file)
  $common_logger.level = ::Logger::DEBUG
  $task_logger = ::Logger.new(task_log_file,'daily')
  $task_logger.level = ::Logger::INFO
when "development" then
  $common_logger = ::Logger.new(log_file)
  $common_logger.level = ::Logger::DEBUG
  $task_logger = ::Logger.new(task_log_file)
  $task_logger.level = ::Logger::DEBUG
when "test" then
  $common_logger = ::Logger.new(log_file)
  $common_logger.level = ::Logger::DEBUG
  $task_logger = ::Logger.new(task_log_file)
  $task_logger.level = ::Logger::DEBUG
else
  $common_logger = ::Logger.new("/dev/null")
end

$common_logger.datetime_format = '%Y-%m-%d %H:%M:%S'
$common_logger.formatter = proc do |severity, datetime, progname, msg|
  %Q~"#{datetime}",#{severity}: #{msg}\n~
    end
$task_logger.datetime_format = '%Y-%m-%d %H:%M:%S'
$task_logger.formatter = proc do |severity, datetime, progname, msg|
  %Q~"#{datetime}",#{severity}: #{msg}\n~
    end

def task_logger
  $task_logger
end

def logger
  $common_logger
end

require "redis/objects"

REDIS ||= Redis.new(
  YAML.load_file(
    File.join(
      File.dirname(__FILE__),
      'config',
      'redis.yml'
    )
  )[ENV['RACK_ENV']]
)
Redis.current = REDIS

helpers do
  def logger
    $common_logger
  end
end

before do
  begin
    s = ""
    s << "\n"
    s << "Processing #{request.path} (for #{request.ip} at #{Time.new.strftime("%Y-%m-%d %H:%M:%S")}) [#{request.request_method}]"
    s << "\nURL: #{request.url.force_encoding('UTF-8')}"
    s << "\nParameters: #{params}" if params
    s << "\n"
    logger << s
  end
end

after do
  begin
    logger << "Completed "
  end
end

configure do
	set :absolute_redirects,false
  #app_file
  #主应用文件，用来检测项目的根路径， views和public文件夹和内联模板。
  set :app_file,__FILE__
  #port
  #监听的端口号。只对内置服务器有用。
  set :port,3000
  #default_encoding
  #默认编码 (默认为 "utf-8")。
  set :default_encoding,"utf-8"
  #dump_errors
  #在log中显示错误。
  set :dump_errors,true
  #environment
  #当前环境，默认是 ENV['RACK_ENV']， 或者 "development" 如果不可用。
  set :environment,ENV['RACK_ENV'].to_sym
  #使用logger级别
  #set :logging,true#Logger::DEBUG
  set :logging,::Logger::DEBUG
  #lock
  #对每一个请求放置一个锁， 只使用进程并发处理请求。
  #如果你的应用不是线程安全则需启动。 默认禁用。
  set :lock,false
  #method_override
  #使用 _method 魔法以允许在旧的浏览器中在 表单中使用 put/delete 方法
  set :method_override,true
  #prefixed_redirects
  #是否添加 request.script_name 到 重定向请求，如果没有设定绝对路径。
  #那样的话 redirect '/foo' 会和 redirect to('/foo')起相同作用。默认禁用。
  set :prefixed_redirects,false
  #public_folder
  #public文件夹的位置。
  set :public_folder,ENV['APP_ROOT'] + "/public"
  #reload_templates
  #是否每个请求都重新载入模板。 在development mode和 Ruby 1.8.6 中被企业（用来 消除一个Ruby内存泄漏的bug）。
  set :reload_templates,development?
  #root
  #项目的根目录。
  set :root,ENV['APP_ROOT']
  #raise_errors
  #抛出异常（应用会停下）。
  set :raise_errors,development?
  #run
  #如果启用，Sinatra会开启web服务器。 如果使用rackup或其他方式则不要启用。
  set :run,false
  #sessions
  #开启基于cookie的sesson。
  set :sessions,false
  #show_exceptions
  #在浏览器中显示一个stack trace。
  set :show_exceptions,development?
  #static
  #Sinatra是否处理静态文件。 当服务器能够处理则禁用。 禁用会增强性能。 默认开启。
  set :static,true
  #views
  #views 文件夹。
  set :views,ENV['APP_ROOT'] + "/views"
end

require 'active_record'
require "sinatra/activerecord"
::ActiveRecord::Base.establish_connection ::YAML::load(::File.open("#{ENV['APP_ROOT']}/config/database.yml"))[ENV["RACK_ENV"]]
::ActiveRecord::Base.logger = $common_logger
::ActiveSupport.on_load(:active_record) do
  self.include_root_in_json = false
  self.default_timezone = :local
  self.time_zone_aware_attributes = false
  self.logger = $common_logger
end
use ::ActiveRecord::ConnectionAdapters::ConnectionManagement
use ::ActiveRecord::QueryCache

if USE_MEM_CACHE
  require 'active_support'
  require 'dalli'
  require 'active_support/cache/dalli_store'
  Dalli.logger = $common_logger
  dalli_opts = {
    :namespace => "ticket_event_api",
    :compress => true,
    :expires_in => 60.minute
  }
  CACHE = ActiveSupport::Cache::DalliStore.new(APP_CONFIG['memcached_url'], dalli_opts)
  DALLI = Dalli::Client.new(APP_CONFIG['memcached_url'], dalli_opts)
  RedisCache = Redis.new(url: APP_CONFIG['redis_url'], :driver => :hiredis)

  require 'second_level_cache'
  SecondLevelCache.configure do |config|
    config.cache_store = CACHE
    config.logger = $common_logger
    config.cache_key_prefix = 'domain'
  end

end

use ::Rack::CommonLogger,$common_logger

# Set autoload directory
AUTOLOAD_PATHS.each do |dir|
  ::Dir.glob(::File.expand_path("../#{dir}", __FILE__) + '/**/*.rb').sort.each do |file|
    require file
  end
end