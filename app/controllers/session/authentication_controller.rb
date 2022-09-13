require "json_web_token"

class Session::AuthenticationController < ApplicationController
  before_action :authorize_request, except: [:login, :confirm_mail, :forget_password, :change_password]

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
      if !(existing_user&.verified_email) && update_object(existing_user, { verified_email: true })
        User.activated_admins.each_entry do |admin_user|
          NotificationMailer.send_activation_notification_mail_for_admins(existing_user, admin_user).deliver_later!
        end
      end
    end
  end

  def forget_password
    safe_operation do
      user = User.filter_by_email(params[:email]).limit(1).first
      time = Time.now + CHANGE_PASSWORD_TIME_OUT.seconds.to_i
      AccountMailer.send_change_password_mail(user).deliver_later!
      render json: { message: FORGET_PASSWORD_MESSAGE, exp: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
    end
  end

  def change_password
    safe_operation do
      decoded = JsonWebToken.decode(params[:token])
      existing_user = User.find(decoded[:user_id])
      update_object(existing_user, { password: params[:password] })
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
