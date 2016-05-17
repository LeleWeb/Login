# encoding: UTF-8
# 渠道适配器
require 'nokogiri'

module AdapterModule


  module InstanceMethods

    attr_accessor :request
    def init( p = {})
      @config = p[:config]
      @retry_time = p[:retry_time] || 3
      @provider_name = p[:provider_name]
    end

    def request_api(method, argv =[])
      argv = [argv] unless argv.is_a?(Array)
      begin
        res = request.send(method_map[method], *argv)
        logger.info("=====require method[DB]===#{method_map[method]}")
        logger.info("=====require res[DB]===#{res}")
        return format(method, res)
      rescue Exception => e
        logger.info("=====require method[DB]===#{method_map[method]}")
        logger.info("=====require error[DB]===#{e.to_s}")
        logger.info e.backtrace.join("\n\t")

        return {code: -20, message: e.to_s} if e.to_s == "timeout"
        return Message::RESULT.call("1115","网络异常")
      end
    end

    def request
      begin
        @request ||= requester.new(:config_file => @config )
        return @request
      rescue Exception => e
        p e.to_s
      end
    end

    # 格式化抓取数据
    def format(method,data)
      if f = formater(method)
        return f.new(data).data
      else
        return data
      end
    end

    def requester
      eval("#{@provider_name}::Request")
    end

    def formater(method)
      eval("#{@provider_name}::Formater::#{method.to_s.camelize}")
    end

  end

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end
