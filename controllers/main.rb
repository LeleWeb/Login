# encoding: UTF-8

get '/' do
  "Hello,World! This is main page of order center. autoreload![GET]"
end

post '/' do
  "Hello,World![POST]"
end

get '/wpwurl' do
  url = "http://211.95.79.214/wpwlockseat"
  url = url + params.to_s
  return url
end

get '/wpwlockseat' do
  test = "xin kong qi"
  return test
end

require "#{ENV['APP_ROOT']}/controllers/controller"

Dir.glob("#{ENV['APP_ROOT']}/controllers/*_controller.rb") { |file|
  if /([\w_]*)_controller\.rb$/.match file
    controller = $1
    require file
    controller_class = eval("#{controller.camelize}Controller")
    next unless controller_class.superclass == Controller    #只支持直接继承

    controller_class.get_get_methods.each do |action|
      get "/#{controller.camelize.downcase}/#{action.to_s}" do
        controller_class.new(self).send(action,params)
      end
      post "/#{controller.camelize.downcase}/#{action.to_s}" do
        controller_class.new(self).send(action,params)
      end
    end
  end
}