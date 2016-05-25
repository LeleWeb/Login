require 'pony'
module Email
  module BaseMail
    class << self
      def send_email(params = {})
        Pony.mail :to => params[:to_user],
          :from => EMAIL_CONFIG['username'].to_s,
          :subject => params[:subject],
          :via => :smtp,
        :via_options => {
          :address => EMAIL_CONFIG['address'],
          :port => EMAIL_CONFIG['port'],
          :user_name => EMAIL_CONFIG['username'],
          :password => EMAIL_CONFIG['password'],
          :domain => EMAIL_CONFIG['domain']
        },
        :headers => { 'Content-Type' => 'text/html' },
        :body => params[:body]
      end
    end
  end
end
