class Session::UserController < ApplicationController
    before_action :authorize_request, except: [:create]
    before_action :is_admin?, only: [:index, :destroy]
    before_action :is_activated?, except: [:create]
    before_action :set_user, only: [:destroy]
    before_action :not_same_user?, only: [:destroy]

    def index
        @users = []
        User.filter(user_filter_params).each_entry{ |user| @users << user&.response_hash}
        render json: { users: @users }
    end

    def create
        user = User.new(user_params)
        save_object(user)
    end

    def destroy
        delete_object(@query_user)
    end

    private
    def user_params
        params.permit(:email, :password, :employee_id)
    end
    
    def user_filter_params
        params.slice(:id, :activated, :email, :role, :employee_id)
    end
end