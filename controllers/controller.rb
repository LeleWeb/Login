# encoding: UTF-8
# 继承这个类的controller可以用
# get_methods :index, :show
# post_methods :update, :delete
# 来定义自己的路由，路由可以直接main.rb中生成
# 简单模式，非REST

class Controller
  include CheckParams
  include ApiAuth
  include HttpReq

  def initialize(app = nil)
    @app = app
  end

  def method_missing(method, *args, &block)
    if @app.respond_to? method
      return @app.send(method, *args, &block)
    end
    super
  end

  def self.get_methods(*methods)
    @_get_methods ||= []
    @_get_methods += methods.map { |e| e.to_sym }
  end
  def self.get_get_methods
    @_get_methods
  end

  def self.post_methods(*methods)
    @_post_methods ||= []
    @_post_methods += methods.map { |e| e.to_sym }
  end
  def self.get_post_methods
    @_post_methods
  end

  def message_for(code, msg, data = {})
    Message::RESULT.call(code, msg, data)
  end

end
