class Profile::UserController < ApplicationController

    def my_profile
        render json: @current_user&.response_hash, status: :ok
    end

    def other_profile
        user = User.filter_by_id(params[:user_id]).limit(1).first
        render json: user&.response_hash, status: :ok
    end

end