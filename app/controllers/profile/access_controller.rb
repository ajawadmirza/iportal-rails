class Profile::AccessController < ApplicationController
    before_action :is_admin?
    before_action :set_user, only: [:change_user_activation, :change_user_role]
    before_action :is_param_user_activated?, only: [:change_user_role]
    before_action :not_same_user?, only: [:change_user_activation, :change_user_role]

    def change_user_activation
        update_params = { activated: params[:activation].to_s.casecmp('true') == 0 }
        update_object(@query_user, update_params)
    end

    def change_user_role
        update_object(@query_user, { role: params[:role] })
    end
end