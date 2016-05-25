# encoding: UTF-8
require "#{ENV['APP_ROOT']}/controllers/controller"
class UserController < Controller
  get_methods :login, :forgot_password, :register, :active_user, :lock_user, :close_account
  post_methods :login, :forgot_password, :register, :active_user, :lock_user, :close_account

  # 登陆
  def login(params = {})
    begin
      email = params[:email]
      pass_word = params[:password]
      user = User.find_user_by_conditions({email: email, password: pass_word})
      return Message::RESULT.call("9999", "用户名或者密码不正确") if user.blank?
      return Message::RESULT.call("9998", "用户需解锁") if user.status == User::USER_STATUS[:lock]
      res = { email: user.eamil, name: user.name}.to_json
      return Message::RESULT.call("0000", "登陆成功", res)
    rescue Exception => e
      logger.info("====#{__method__} error==#{e.to_s}")
      return Message::RESULT.call("1114", "登陆异常")
    end
  end

  # 忘记密码
  def forgot_password(params = {})
    begin
      Email::BaseMail.send_email(to_user: params[:email], subject: "忘记密码", body: erb(:'email/forgot_password', :locals => {:email => params[:email]}))
      return Message::RESULT.call("0000", "邮件发送成功")
    rescue Exception => e
      logger.info("====#{__method__} error==#{e.to_s}")
      return Message::RESULT.call("1114", "发送邮件异常")
    end
  end

  # 用户注册
  def register(params = {})
    begin
      u = User.new
      u.email = params[:email]
      u.password = params[:pass_word]
      u.name = params[:name]
      u.description = params[:description]
      u.save # u.errors[:eamil]
      Email::BaseMail.send_email(to_user: params[:email], subject: "申请成功", body: erb(:'email/apply_success'))
      return Message::RESULT.call("0000", "用户注册成功")
    rescue Exception => e
      logger.info("====#{__method__} error==#{e.to_s}")
      return Message::RESULT.call("1114", "用户注册异常")
    end
  end

  # 激活用户
  def active_user(params = {})
    begin
      user = User.find_user_by_conditions(email: params[:email])
      return Message::RESULT.call("9997", "此用户不存在") if user.blank?
      user.status = 1
      user.save
      return Message::RESULT.call("0000", "激活用户成功")
    rescue Exception => e
      logger.info("====#{__method__} error==#{e.to_s}")
      return Message::RESULT.call("1114", "激活用户异常")
    end
  end

  # 锁用户
  def lock_user(params = {})
    begin
      user = User.find_user_by_conditions(email: params[:email])
      return Message::RESULT.call("9997", "此用户不存在") if user.blank?
      user.status = 0
      user.save
      return Message::RESULT.call("0000", "锁定用户成功")
    rescue Exception => e
      logger.info("====#{__method__} error==#{e.to_s}")
      return Message::RESULT.call("1114", "锁定用户异常")
    end
  end

  # 关闭账号
  def close_account(params = {})
    begin
      user = User.find_user_by_conditions(email: params[:email])
      return Message::RESULT.call("9997", "此用户不存在") if user.blank?
      user.delete
      return Message::RESULT.call("0000", "关闭账号成功")
    rescue Exception => e
      logger.info("====#{__method__} error==#{e.to_s}")
      return Message::RESULT.call("1114", "关闭账号异常")
    end
  end
end
