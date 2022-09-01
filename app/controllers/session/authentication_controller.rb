require 'json_web_token'

class Session::AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login
    before_action :is_activated?, except: :login

    def login
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.now + SESSION_TIME_OUT.seconds.to_i
          render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), email: @user.email, role: @user.role, activated?: @user.activated }, status: :ok
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
    end

    private

    def login_params
        params.permit(:email, :password)
    end
end