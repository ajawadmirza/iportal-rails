require 'json_web_token'

class Session::AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login
    before_action :is_activated?, except: :login

    def login
        @current_user = User.find_by_email(params[:email])
        if @current_user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: @current_user.id)
          time = Time.now + SESSION_TIME_OUT.seconds.to_i
          render json: @current_user&.response_hash.merge({ token: token, exp: time.strftime("%m-%d-%Y %H:%M") }), status: :ok
        else
          render json: { error: INVALID_CREDENTIALS_MESSAGE }, status: :unauthorized
        end
    end

    private

    def login_params
        params.permit(:email, :password)
    end
end