require 'json_web_token'

class ApplicationController < ActionController::API
  before_action :authorize_request

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def is_admin?
    render json: { error: "user doesn't have enough rights to access." }, status: :unauthorized unless @current_user.role == '1'
  end

  def is_activated?
    render json: { error: "user account is not activated yet. please contact administrator to approve." }, status: :unauthorized unless @current_user&.activated
  end

  def not_same_user?
    render json: { errors: 'you cannot apply this operation on your own profile.' }, status: :unprocessable_entity if @current_user == @query_user
  end

  def set_user
    begin
      @query_user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "no such user found in the records." }, status: :not_found
    end
  end
end
