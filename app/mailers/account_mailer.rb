require "json_web_token"

class AccountMailer < ApplicationMailer
  def send_set_password_mail(user)
    @user = user
    mail(to: @user.email, from: ENV["SMTP_EMAIL"], subject: SET_PASSWORD_EMAIL_SUBJECT)
  end

  def send_email_confirmation_mail(user)
    @user = user
    token = JsonWebToken.encode(user_id: @user.id)
    @confirm_email_url = ENV["HOST"] + "/session/confirm-mail?token=#{token}"
    mail(to: @user.email, from: ENV["SMTP_EMAIL"], subject: EMAIL_CONFIRMATION_SUBJECT)
  end
end
