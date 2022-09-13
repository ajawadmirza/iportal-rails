require "json_web_token"

class Session::AuthenticationController < ApplicationController
  before_action :authorize_request, except: [:login, :confirm_mail]

  def login
    @current_user = User.find_by_email(params[:email])
    if @current_user&.authenticate(params[:password])
      if @current_user.verified_email
        token = JsonWebToken.encode(user_id: @current_user.id)
        time = Time.now + SESSION_TIME_OUT.seconds.to_i
        render json: @current_user&.response_hash.merge({ token: token, exp: time.strftime("%m-%d-%Y %H:%M") }), status: :ok
      else
        render json: { error: UNVERIFIED_EMAIL_MESSAGE }, status: :unprocessable_entity
      end
    else
      render json: { error: INVALID_CREDENTIALS_MESSAGE }, status: :unauthorized
    end
  end

  def confirm_mail
    safe_operation do
      decoded = JsonWebToken.decode(params[:token])
      existing_user = User.find(decoded[:user_id])
      if update_object(existing_user, { verified_email: true })
        User.activated_admins.each_entry do |admin_user|
          NotificationMailer.send_activation_notification_mail_for_admins(existing_user, admin_user).deliver_now!
        end
      end
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
