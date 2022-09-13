require "json_web_token"

class NotificationMailer < ApplicationMailer

  def send_activation_notification_mail_for_admins(user, admin_user)
    @user = user
    mail(to: admin_user.email, from: ENV["SMTP_EMAIL"], subject: ACTIVATE_ACCOUNT_NOTIFICATION_SUBJECT)
  end

  def send_activation_confirmation_mail_to_user(user)
    @user = user
    mail(to: user.email, from: ENV["SMTP_EMAIL"], subject: ACTIVATION_CONFIRMATION_NOTIFICATION_SUBJECT)
  end

  def send_interview_notification_mail_to_interviewers(interviewer, interview, scheduler)
    @scheduler = scheduler
    @user = interviewer
    @interview = interview
    mail(to: @user.email, from: ENV["SMTP_EMAIL"], subject: INTERVIEW_NOTIFICATION_SUBJECT)
  end

end
