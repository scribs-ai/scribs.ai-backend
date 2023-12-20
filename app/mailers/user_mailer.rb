# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  default from: 'kapil@scribs.ai'
	def mail_sent(user)
    @user = user
    mail(to: @user.email, subject: 'Login Link')
  end
end

  