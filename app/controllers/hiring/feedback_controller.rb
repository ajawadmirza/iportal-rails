require 's3_file_handler'

class Hiring::FeedbackController < ApplicationController
    before_action :is_activated?
    before_action :is_maintainer?, except: [:create, :destroy]

    def index
        all_feedbacks = { feedbacks: [] }
        Feedback.all.each do |feedback|
            feedback_obj = feedback.with_interview_and_candidate_details
            all_feedbacks[:feedbacks] << feedback_obj
        end
        render json: all_feedbacks
    end

    def create
        begin
            file_data = params[:file]
            interview = Interview.find(params[:interview_id])
            if user_permission_for_feedback?(interview)
                upload_result = FileHandler.upload_file(file_data[:content_type], file_data[:extension], file_data[:file])
                params = set_other_params(url: upload_result[:url], key: upload_result[:key])
                feedback = Feedback.new(feedback_params)
                if feedback.save
                    render json: feedback.with_interview_and_candidate_details
                else
                    FileHandler.delete_file(upload_result[:key])
                    render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
                end
            else
                render json: { error: "user doesn't have enough rights to access." }, status: :unauthorized
            end
        rescue => e
            FileHandler.delete_file(upload_result[:key]) if upload_result[:key]
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def destroy
        begin
            feedback = Feedback.find(params[:feedback_id].to_i)
            if user_permission_for_feedback?(feedback.interview)
                FileHandler.delete_file(feedback.file_key) if feedback.file_key
                result = feedback.destroy
                if result
                    render json: { message: 'feedback is successfully deleted' }, status: :ok
                else
                    render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
                end
            else
                render json: { error: "user doesn't have enough rights to access." }, status: :unauthorized
            end
        rescue => e
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    private

    def feedback_params
        params.permit(:status, :remarks, :file_url, :file_key, :interview_id, :user_id)
    end

    def set_other_params(options = {})
        params[:file_url] = options[:url]
        params[:file_key] = options[:key]
        params[:user_id] = @current_user.id
        params[:interview_id] = Interview.find(params[:interview_id]).id
        params
    end

    def user_permission_for_feedback?(interview)
        @current_user.role == ADMIN_USER_ROLE || @current_user.role == MAINTAINER_USER_ROLE || interview.users.ids.include?(@current_user.id)
    end
end