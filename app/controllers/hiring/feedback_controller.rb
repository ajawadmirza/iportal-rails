require "s3_file_handler"

class Hiring::FeedbackController < ApplicationController
  before_action :is_activated?
  before_action :is_maintainer?, except: [:create, :destroy, :given_by_self_user, :update]

  def index
    @feedbacks = []
    Feedback.filter(feedback_filter_params).each_entry { |feedback| @feedbacks << feedback&.with_interview_and_candidate_details }
    render json: { feedbacks: @feedbacks }
  end

  def show
    safe_operation do
      feedback = Feedback.filter_by_id(params[:id]).limit(1).first
      render json: feedback&.with_interview_and_candidate_details
    end
  end

  def create
    safe_operation do
      file_data = params[:file]
      interview = Interview.find(params[:interview_id])
      permission = user_permission_for_feedback?(interview)
      perform_if_permitted(permission) do
        upload_result = FileHandler.upload_file(file_data[:content_type], file_data[:extension], file_data[:file])
        params = set_feedback_params(url: upload_result[:url], key: upload_result[:key])
        feedback = Feedback.new(feedback_params)
        save_object(feedback, upload_result[:key])
      end
    end
  end

  def update
    safe_operation do
      feedback = Feedback.find(params[:id])
      permission = user_permission_for_feedback?(feedback.interview)
      perform_if_permitted(permission) do
        upload_result = FileHandler.update_file_with_new_key(feedback&.file_key, params[:file][:content_type], params[:file][:extension], params[:file][:file]) if params[:file]
        params = set_feedback_params(upload_result || {})
        update_object(feedback, feedback_params.except(:interview_id))
      end
    end
  end

  def destroy
    safe_operation do
      feedback = Feedback.find(params[:feedback_id].to_i)
      permission = user_permission_for_feedback?(feedback.interview)
      perform_if_permitted(permission) { delete_object(feedback, feedback.file_key) }
    end
  end

  def given_by_self_user
    render_feedback_for_user(@current_user.id)
  end

  def given_by_query_user
    render_feedback_for_user(params[:user_id])
  end

  private

  def feedback_filter_params
    params.slice(:id, :status, :remarks, :file_url)
  end

  def render_feedback_for_user(user_id)
    user_feedbacks = []
    feedbacks = Feedback.filter(feedback_filter_params).filter_by_given_by(user_id)
    feedbacks.each_entry { |feedback| user_feedbacks << feedback&.with_interview_and_candidate_details }
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
