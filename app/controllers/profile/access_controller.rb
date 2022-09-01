class Profile::AccessController < ApplicationController
    before_action :authorize_request
    before_action :is_admin?
    before_action :set_user, only: [:change_user_activation, :change_user_role]
    before_action :not_same_user?, only: [:change_user_activation, :change_user_role]

    def change_user_activation
        begin
            activation = params[:activation].to_s.casecmp('true') == 0
            @query_user.update_attributes!(activated: activation)
            render json: @query_user, except: [:password_digest], status: :ok
        rescue Exception
            render json: { error: @query_user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def change_user_role
        begin
            @query_user.update_attributes!(role: params[:role].to_s)
            render json: @query_user, except: [:password_digest], status: :ok
        rescue Exception
            render json: { error: @query_user.errors.full_messages }, status: :unprocessable_entity
        end
    end
end