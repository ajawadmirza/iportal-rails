require 's3_file_handler'

class Pool::CandidateController < ApplicationController
    before_action :is_activated?

    def index
        @candidates = []
        Candidate.all.each_entry{ |candidate| @candidates << candidate&.with_interviews_interviewers_and_feedback}
        render json: { candidates: @candidates }
    end

    def create
        begin
            file_data = params[:cv]
            params = upload_and_set_urls(file_data)
            params = set_candidate_params
            candidate = Candidate.new(candidate_params)
            save_object(candidate, params[:cv_key])
        rescue => e
            FileHandler.delete_file(params[:cv_key]) if params[:cv_key]
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def update
        begin
            candidate = Candidate.find(params[:id])
            if user_permission_for_candidate?(candidate)
                if file_data = params[:cv]
                    FileHandler.delete_file(candidate&.cv_key)
                    params = upload_and_set_urls(file_data)
                end
                update_object(candidate, candidate_params.except(:user_id))
            else
                render json: { error: INVALID_ACCESS_RIGHTS_MESSAGE }, status: :unauthorized
            end
        rescue => e
            FileHandler.delete_file(params[:cv_key]) if params && params[:cv_key]
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def destroy
        begin
            candidate = Candidate.find(params[:id])
            if user_permission_for_candidate?(candidate)
                FileHandler.delete_file(candidate&.cv_key)
                delete_object(candidate)
            else
                render json: { error: INVALID_ACCESS_RIGHTS_MESSAGE }, status: :unauthorized
            end
        rescue => e
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def referrals_by_self_user
        render_candidates_by_user(@current_user.id)
    end

    def referrals_by_query_user
        render_candidates_by_user(params[:user_id])
    end

    private

    def upload_and_set_urls(file_data)
        upload_result = FileHandler.upload_file(file_data[:content_type], file_data[:extension], file_data[:file])
        params[:cv_url] = upload_result[:url]
        params[:cv_key] = upload_result[:key]
        params
    end

    def render_candidates_by_user(user_id)
        referrals = []
        candidates = Candidate.where(:user_id => user_id)
        candidates.each_entry{ |candidate| referrals << candidate&.with_interviews_interviewers_and_feedback }
        render json: { candidates: referrals }
    end
    
    def candidate_params
        params.permit(:name, :experience_years, :stack, :cv_url, :cv_key, :status, :user_id)
    end

    def set_candidate_params(options = {})
        params[:status] = DEFAULT_CANDIDATE_STATUS
        params[:user_id] = @current_user.id
        params
    end

    def user_permission_for_candidate?(candidate)
        @current_user.role == ADMIN_USER_ROLE || @current_user.role == MAINTAINER_USER_ROLE || candidate.user_id == @current_user.id
    end
end