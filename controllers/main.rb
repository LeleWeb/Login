# encoding: UTF-8
require "#{ENV['APP_ROOT']}/controllers/controller"

get '/' do
  "Hello,World![GET]"
end

post '/' do
  "Hello,World![POST]"
end

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