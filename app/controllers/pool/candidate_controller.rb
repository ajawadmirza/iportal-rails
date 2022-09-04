require 's3_file_handler'

class Pool::CandidateController < ApplicationController
    before_action :is_activated?

    def index
        @candidates = Candidate.all
        render json: { candidates: @candidates }
    end

    def create
        begin
            file_data = params[:cv]
            upload_result = FileHandler.upload_file(file_data[:content_type], file_data[:extension], file_data[:file])
            params = set_other_params(url: upload_result[:url], key: upload_result[:key])
            candidate = Candidate.new(candidate_params)
            if candidate.save
                render json: candidate
            else
                FileHandler.delete_file(upload_result[:key])
                render json: { errors: candidate.errors.full_messages }, status: :unprocessable_entity
            end
        rescue => e
            FileHandler.delete_file(upload_result[:key]) if upload_result[:key]
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    private
    
    def candidate_params
        params.permit(:name, :experience_years, :stack, :cv_url, :cv_key, :status, :referred_by, :user_id)
    end

    def set_other_params(options = {})
        params[:cv_url] = options[:url]
        params[:cv_key] = options[:key]
        params[:status] = DEFAULT_CANDIDATE_STATUS
        params[:referred_by] = @current_user.email
        params[:user_id] = @current_user.id
        params
    end
end