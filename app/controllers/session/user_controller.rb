class Session::UserController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :is_admin?, only: [:index, :destroy]
  before_action :is_activated?, except: [:create]
  before_action :set_user, only: [:destroy]
  before_action :not_same_user?, only: [:destroy]

  def index
    @users = []
    User.filter(user_filter_params).each_entry { |user| @users << user&.response_hash }
    render json: { users: @users }
  end

  def create
    user = User.new(user_params)
    save_user_or_update(user, user_params)
  end

  def destroy
    delete_object(@query_user)
  end

  private

  def user_params
    params.permit(:email, :password, :employee_id)
  end

  def user_filter_params
    params.slice(:id, :activated, :email, :role, :employee_id, :verified_email)
  end

  def save_user_or_update(user, params)
    safe_operation do
      if user.save
        render json: user&.response_hash
        AccountMailer.send_email_confirmation_mail(user).deliver_later!
      elsif email_taken(user)
        existing_user = User.filter_by_email(user.email).limit(1).first
        unless existing_user.verified_email
          update_object(existing_user, user_params.except(:email))
          AccountMailer.send_email_confirmation_mail(existing_user).deliver_later!
        else
          render json: { errors: ALREADY_TAKEN_AND_ACTIVATED }, status: :unprocessable_entity
        end
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def email_taken(user)
    return false unless user.errors.full_messages.length == 1 && user.errors.has_key?(:email)
    user.errors.details[:email].first[:error].eql?(:taken)
  end
end
