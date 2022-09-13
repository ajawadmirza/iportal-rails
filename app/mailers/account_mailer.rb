require "json_web_token"

class AccountMailer < ApplicationMailer
  def send_set_password_mail(user)
    before_mail_check do
      @user = user
      mail(to: @user.email, from: ENV["SMTP_EMAIL"], subject: SET_PASSWORD_EMAIL_SUBJECT)
    end
  end

  def send_email_confirmation_mail(user)
    before_mail_check do
      @user = user
      token = JsonWebToken.encode({user_id: @user.id}, EMAIL_CONFIRMATION_TIME_OUT.seconds.from_now)
      @confirm_email_url = ENV["HOST"] + "/session/confirm-mail?token=#{token}"
      mail(to: @user.email, from: ENV["SMTP_EMAIL"], subject: EMAIL_CONFIRMATION_SUBJECT)
    end
  end

  def send_change_password_mail(user)
    before_mail_check do
      @user = user
      token = JsonWebToken.encode({user_id: @user.id}, CHANGE_PASSWORD_TIME_OUT.seconds.from_now)
      @change_password_url = ENV["FRONTEND_URL"] + "#{FRONTEND_CHANGE_PASSWORD_ENDPOINT}?token=#{token}"
      mail(to: @user.email, from: ENV["SMTP_EMAIL"], subject: CHANGE_PASSWORD_SUBJECT)
    end
  end
end
