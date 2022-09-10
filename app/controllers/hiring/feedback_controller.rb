require 's3_file_handler'

class Hiring::FeedbackController < ApplicationController
    before_action :is_activated?
    before_action :is_maintainer?, except: [:create, :destroy, :given_by_self_user, :update]

    def index
        @feedbacks = []
        Feedback.all.each_entry{ |feedback| @feedbacks << feedback&.with_interview_and_candidate_details}
        render json: { feedbacks: @feedbacks }
    end

    def create
        begin
            file_data = params[:file]
            interview = Interview.find(params[:interview_id])
            if user_permission_for_feedback?(interview)
                upload_result = FileHandler.upload_file(file_data[:content_type], file_data[:extension], file_data[:file])
                params = set_feedback_params(url: upload_result[:url], key: upload_result[:key])
                feedback = Feedback.new(feedback_params)
                save_object(feedback, upload_result[:key])
            else
                render json: { error: INVALID_ACCESS_RIGHTS_MESSAGE }, status: :unauthorized
            end
        rescue => e
            FileHandler.delete_file(upload_result[:key]) if upload_result[:key]
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def update
        begin
            feedback = Feedback.find(params[:id])
            if user_permission_for_feedback?(feedback.interview)
                if file_data = params[:file]
                    FileHandler.delete_file(feedback&.file_key)
                    upload_result = FileHandler.upload_file(file_data[:content_type], file_data[:extension], file_data[:file])
                end
                params = set_feedback_params(upload_result || {})
                update_object(feedback, feedback_params.except(:interview_id))
            else
                render json: { error: INVALID_ACCESS_RIGHTS_MESSAGE }, status: :unauthorized
            end
        rescue => e
            FileHandler.delete_file(params[:file_key]) if params && params[:file_key]
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def destroy
        begin
            feedback = Feedback.find(params[:feedback_id].to_i)
            if user_permission_for_feedback?(feedback.interview)
                delete_object(feedback, feedback.file_key)
            else
                render json: { error: INVALID_ACCESS_RIGHTS_MESSAGE }, status: :unauthorized
            end
        rescue => e
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def given_by_self_user
        render_feedback_for_user(@current_user.id)
    end

    def given_by_query_user
        render_feedback_for_user(params[:user_id])
    end

    private

    def render_feedback_for_user(user_id)
        user_feedbacks = []
        feedbacks = Feedback.where(:user_id => user_id)
        feedbacks.each_entry{ |feedback| user_feedbacks << feedback&.with_interview_and_candidate_details }
        render json: { feedbacks: user_feedbacks }
    end

    def feedback_params
        params.permit(:status, :remarks, :file_url, :file_key, :interview_id, :user_id)
    end

    def set_feedback_params(options = {})
        params[:file_url] = options[:url] if options[:url]
        params[:file_key] = options[:key] if options[:key]
        params[:user_id] = @current_user.id
        params[:interview_id] = Interview.find(params[:interview_id]).id if params && params[:interview_id]
        params
    end

    def user_permission_for_feedback?(interview)
        @current_user.role == ADMIN_USER_ROLE || @current_user.role == MAINTAINER_USER_ROLE || interview.users.ids.include?(@current_user.id)
    end
end