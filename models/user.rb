# encoding: UTF-8
class User < ActiveRecord::Base
  USER_STATUS = {
  	lock: 0,
  	activity: 1
  }
	def self.find_user_by_conditions(hash = {})
    find(:first, :conditions => hash)
	end
end
