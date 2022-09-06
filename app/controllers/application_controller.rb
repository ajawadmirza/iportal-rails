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

  def is_maintainer?
    render json: { error: INVALID_ACCESS_RIGHTS_MESSAGE }, status: :unauthorized unless @current_user.role == ADMIN_USER_ROLE || @current_user.role == MAINTAINER_USER_ROLE
  end
  
  def is_admin?
    render json: { error: INVALID_ACCESS_RIGHTS_MESSAGE }, status: :unauthorized unless @current_user.role == ADMIN_USER_ROLE
  end

  def is_activated?
    render json: { error: INACTIVATED_USER_MESSAGE }, status: :unauthorized unless @current_user&.activated
  end

  def is_param_user_activated?
    render json: { error: INACTIVATED_USER_MESSAGE }, status: :unprocessable_entity unless @query_user&.activated
  end

  def not_same_user?
    render json: { errors: SAME_USER_MESSAGE }, status: :unprocessable_entity if @current_user == @query_user
  end

  def set_user
    begin
      @query_user = User.find(params[:id])
    rescue => e
      render json: { error: e.message }, status: :not_found
    end
  end

  def delete_object(object, file_key = nil)
    begin
      result = object.destroy
      if result
        FileHandler.delete_file(file_key) if file_key
        render json: { message: object.class.name+DELETED_MESSAGE }, status: :ok
      else
        FileHandler.delete_file(file_key) if file_key
        render json: { errors: object.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      FileHandler.delete_file(file_key) if file_key
      render json: { errors: e.message }, status: :internal_server_error
    end
  end

  def save_object(object, file_key = nil)
    begin
      if object.save
        render json: object&.response_hash
      else
          FileHandler.delete_file(file_key)
          render json: { errors: object.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      FileHandler.delete_file(file_key) if file_key
      render json: { errors: e.message }, status: :internal_server_error
    end
  end
end
