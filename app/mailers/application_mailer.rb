class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def before_mail_check
    yield if SEND_EMAIL_STATUS
  end
end
