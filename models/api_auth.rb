# encoding: utf-8
require "digest/md5"

module ApiAuth
  SECRET_KEY = AppConfig['secret_key']

	def params_md5_check(key, request_url, result)
    params_str = CGI.unescape(request_url.split("?").last.sub(/\&sig\=[^\&]*/, ''))
    Digest::MD5.hexdigest("#{params_str}#{SECRET_KEY[key]}").downcase == result.downcase if key && result
  end

  def search_check(key)
    key && SEARCH_KEYS.include?(key)
  end

  def order_check(key)
    key && ORDER_KEYS.include?(key)
  end
end
