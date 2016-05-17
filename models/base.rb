# -*- encoding: UTF-8 -*-
##############################################################
# File Name: models/base.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年09月12日 星期四 09时48分20秒
##############################################################

#消息处理,1表示成功,2表示失败
module Message
  RESULT= proc do |code, msg, hash = {}|
    res = {
      respCode: code,
      respMsg: msg || ""
    }
    res.merge!(hash) if hash.present?
    #logger.info("----message::result::#{res}")
    res.to_json
  end
end

#改写Hash的to_param方法,取消排序,按照原来顺序转换成param
class Hash
  def to_param(namespace = nil)
    collect do |key, value|
      value.to_query(namespace ? "#{namespace}[#{key}]" : key)
    end * '&'
  end
end

#添加参数检查方法
module CheckParams
  def check_params(*args)
    rs = args.map do |arg|
      if !params[arg.to_sym] || params[arg.to_sym].empty?
        if block_given?
          yield arg.to_sym
        else
          raise ArgumentError.new("missing params[:#{arg.to_sym}]")
        end
      end
      params[arg.to_sym]
    end
    return rs.join if rs.size == 1
    rs
  end

  def check_data(*arr)
    return true if arr.class != Array
    return false if (arr.first.blank? && arr.last.blank?) || (arr.first && arr.last)
    true
  end
end

#http请求
module HttpReq
  def http_get(url, req_options)
    connect_options = {
      :connect_timeout => 30,
      :inactivity_timeout => 30
    }
    http_response = nil
    EM.run do
      logger.info("----http_get::url:;#{url}, query: #{req_options}")
      http = EM::HttpRequest.new(url, connect_options).get(req_options)
      http.callback {
        http_response = http.response
        EM.stop
      }
      http.errback{
        p [:HTTP_ERROR, http.error]
        EM.stop
      }
    end
    return http_response
  end

  def http_post(url, query)
    connect_options = {
      :connect_timeout => 30,
      :inactivity_timeout => 30
    }
    http_response = nil
    EM.run do
      logger.info("----http_post::url:;#{url}, query: #{query}")
      http = EM::HttpRequest.new(url, connect_options).post(query: query)
      http.callback {
        http_response = http.response
        EM.stop
      }
      http.errback{
        p [:HTTP_ERROR, http.error]
        EM.stop
      }
    end
    return http_response
  end

  def https_get(url, query)
    uri = URI.parse(url)
    uri.query = query.to_param
    logger.info("in htts_get-----uri::#{uri.inspect}")
    http = Net::HTTP.new(uri.host, uri.port)
    if ENV['RACK_ENV'] == "production"
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    req = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(req)
    logger.info("in htts_get-----res::#{res}")
    res = res.body
    logger.info("in htts_get-----res body::#{res}")
    return res
  end

  def https_post(url, query)
    uri = URI.parse(url)
    uri.query = query.to_param
    logger.info("in htts_get-----uri::#{uri.inspect}")
    http = Net::HTTP.new(uri.host, uri.port)
    if ENV['RACK_ENV'] == "production"
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    req = Net::HTTP::Post.new(uri.request_uri)
    res = http.request(req)
    logger.info("in htts_get-----res::#{res}")
    res = res.body
    logger.info("in htts_get-----res body::#{res}")
    return res
  end
end
