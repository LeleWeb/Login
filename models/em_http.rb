# -*- encoding : utf-8 -*-
# 异步请求方法
require 'eventmachine'
require 'em-http-request'
require "fiber"

class EmHttp
  CONNECT_TIMEOUT = 45    # 建立连接超时时间
  CONNECT_OPTIONS = { connect_timeout: CONNECT_TIMEOUT }   # 定死不要改了
  HEADER_OPTION = { "Content-Type" => "application/x-www-form-urlencoded",
                    'Accept-Encoding' => 'gzip,deflate'}
  KEEPALIVE_OPTION = true

  def self.post(url, params ={})
    EmHttp.new.post(url,params)
  end

  def self.get(url)
    EmHttp.new.get(url)
  end

  def self.send_message(host, params)
    status = 0
    EM.run do
      Fiber.new {

        fib = Fiber.current
        connect_options = {
          connect_timeout: 20,
          inactivity_timeout: 20
        }
        req = EM::HttpRequest.new(host, connect_options).get :query => params
        logger.info("==========em_http res:#{req}")

        req.callback do |response|
          fib.resume(response)
          status = 1
        end
        req.errback do |err|
          fib.resume(err)
          status = 0
        end
        Fiber.yield

        EM.stop
      }.resume
    end
    status
  end

  def get(url)
    em_fetch(url, {}, :get)
  end

  def post(url,params = {})
    em_fetch(url, params, :post)
  end

  def em_fetch(url, params ={},method = 'get')
    req_params = []
    http_response = nil

    host, params_str = url.split("?")
    req_params << params_str
    req_params += params.map{|k,v| "#{k}=#{v}"} unless params.blank?
    params_str = req_params.join("&")
    EM.run do
      Fiber.new {
        http_response = async_fetch(host, { body: params_str }, method.to_sym).response
        EM.stop
      }.resume
    end
    http_response
  end

  def async_fetch(url, params , method )
    f = Fiber.current

    request_options = {
      :keepalive => KEEPALIVE_OPTION,
      :body => params[:body],
      :head => HEADER_OPTION
    }
    http = EM::HttpRequest.new(url, CONNECT_OPTIONS).send(method,request_options)
    http.callback { f.resume(http) }
    http.errback { f.resume(http) }
    Fiber.yield
    p [:HTTP_ERROR, http.error] if http.error
    http
  end

end
