# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  default from: 'kapil@scribs.ai'

  def otp_code_sent_by_mail(user)
    @user = user
    mail(to: @user.email, subject: 'Otp for authentication')
  end

  def subscription_invoice_sent(user, invoice)
    @user = user
    @invoice = invoice
    mail(to: @user.email, subject: 'Invoice of subscription plan')
  end
  
  def renew_subscription(user,notification)
    @user = user
    @notification = notification
    mail(to: @user.email, subject: 'Subscription Renewal')
  end
end

  