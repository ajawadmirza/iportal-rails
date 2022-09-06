require 's3_file_handler'

class Pool::CandidateController < ApplicationController
    before_action :is_activated?

    def index
        @candidates = []
        Candidate.all.each_entry{ |candidate| @candidates << candidate&.response_hash}
        render json: { candidates: @candidates }
    end

    def create
        begin
            file_data = params[:cv]
            upload_result = FileHandler.upload_file(file_data[:content_type], file_data[:extension], file_data[:file])
            params = set_candidate_params(url: upload_result[:url], key: upload_result[:key])
            candidate = Candidate.new(candidate_params)
            save_object(candidate, upload_result[:key])
        rescue => e
            FileHandler.delete_file(upload_result[:key]) if upload_result[:key]
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    private
    
    def candidate_params
        params.permit(:name, :experience_years, :stack, :cv_url, :cv_key, :status, :user_id)
    end

    def set_candidate_params(options = {})
        params[:cv_url] = options[:url]
        params[:cv_key] = options[:key]
        params[:status] = DEFAULT_CANDIDATE_STATUS
        params[:user_id] = @current_user.id
        params
    end
end