class Profile::AccessController < ApplicationController
  before_action :is_admin?
  before_action :set_user, only: [:change_user_activation, :change_user_role]
  before_action :is_param_user_activated?, only: [:change_user_role]
  before_action :not_same_user?, only: [:change_user_activation, :change_user_role]

  def change_user_activation
    if @query_user.verified_email
      user_activated = params[:activation].to_s.casecmp("true") == 0
      update_params = { activated: user_activated }
      if update_object(@query_user, update_params) && user_activated == true
        NotificationMailer.send_activation_confirmation_mail_to_user(@query_user).deliver_later!
      end
    else
      render json: { error: UNVERIFIED_EMAIL_MESSAGE }, status: :unprocessable_entity
    end
  end

  def change_user_role
    update_object(@query_user, { role: params[:role] })
  end
end
