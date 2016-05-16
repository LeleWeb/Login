# encoding: UTF-8
require "#{ENV['APP_ROOT']}/controllers/controller"
class LoginController < Controller
  get_methods :login
  post_methods :login

  def login(params = {})
    begin
      res = { user: "guanyuanchao" }
      return Message::RESULT.call("0000", "查询成功", res)
    rescue Exception => e
      logger.info("====#{__method__} error==#{e.to_s}")
      return Message::RESULT.call("1114", "登陆失败失败,请重试")
    end
  end
end
