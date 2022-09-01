class Session::UserController < ApplicationController
    before_action :authorize_request, except: [:create]
    before_action :is_admin?, only: [:index, :destroy]
    before_action :is_activated?, except: [:create]
    before_action :set_user, only: [:destroy]
    before_action :not_same_user?, only: [:destroy]

    def index
        @users = User.all
        render json: { users: @users }, except: [:password_digest]
    end

    def create
        user = User.new(user_params)
        if user.save
            render json: user, except: [:password_digest]
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        result = @query_user.destroy
        if result
            render json: { message: 'user is successfully deleted' }, status: :ok
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private
    def user_params
        params.permit(:email, :password)
    end
end