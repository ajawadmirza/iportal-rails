class Profile::AccessController < ApplicationController
    before_action :authorize_request
    before_action :is_admin?
    before_action :set_user, only: [:change_user_activation, :change_user_role]
    before_action :is_param_user_activated?, only: [:change_user_role]
    before_action :not_same_user?, only: [:change_user_activation, :change_user_role]

    def change_user_activation
        activation = params[:activation].to_s.casecmp('true') == 0
        @query_user.activated = activation
        save_record
    end

    def change_user_role
        @query_user.role = params[:role].to_s
        save_record
    end

    private

    def save_record
        if @query_user.save
            render json: @query_user, except: [:password_digest], status: :ok
        else
            render json: { error: @query_user.errors.full_messages }, status: :unprocessable_entity
        end
    end
end