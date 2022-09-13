require "json_web_token"

class NotificationMailer < ApplicationMailer

  def send_activation_notification_mail_for_admins(user, admin_user)
    @user = user
    mail(to: admin_user.email, from: ENV["SMTP_EMAIL"], subject: ACTIVATE_ACCOUNT_NOTIFICATION_SUBJECT)
  end

end
