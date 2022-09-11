require "s3_file_handler"

class Pool::CandidateController < ApplicationController
  before_action :is_activated?

  def index
    @candidates = []
    Candidate.filter(candidate_filter_params).each_entry { |candidate| @candidates << candidate&.with_interviews_interviewers_and_feedback }
    render json: { candidates: @candidates }
  end

  def show
    safe_operation do
      candidate = Candidate.filter_by_id(params[:id]).limit(1).first
      render json: candidate&.with_interviews_interviewers_and_feedback
    end
  end

  def create
    safe_operation do
      file_data = params[:cv]
      params = upload_and_set_urls(file_data)
      params = set_candidate_params
      candidate = Candidate.new(candidate_params)
      save_object(candidate, params[:cv_key])
    end
  end

  def update
    safe_operation do
      candidate = Candidate.find(params[:id])
      permission = user_permission_for_candidate?(candidate)
      perform_if_permitted(permission) do
        if file_data = params[:cv]
          FileHandler.delete_file(candidate&.cv_key)
          params = upload_and_set_urls(file_data)
        end
        update_object(candidate, candidate_params.except(:user_id))
      end
    end
  end

  def destroy
    safe_operation do
      candidate = Candidate.find(params[:id])
      permission = user_permission_for_candidate?(candidate)
      perform_if_permitted(permission) { delete_object(candidate, candidate&.cv_key) }
    end
  end

  def referrals_by_self_user
    render_candidates_by_user(@current_user.id)
  end

  def referrals_by_query_user
    render_candidates_by_user(params[:user_id])
  end

  private

  def candidate_filter_params
    params.slice(:id, :name, :cv_url, :stack, :experience_years, :total_interviews, :referred_by)
  end

  def upload_and_set_urls(file_data)
    upload_result = FileHandler.upload_file(file_data[:content_type], file_data[:extension], file_data[:file])
    params[:cv_url] = upload_result[:url]
    params[:cv_key] = upload_result[:key]
    params
  end

  def render_candidates_by_user(user_id)
    referrals = []
    candidates = Candidate.filter(candidate_filter_params).filter_by_referred_by(user_id)
    candidates.each_entry { |candidate| referrals << candidate&.with_interviews_interviewers_and_feedback }
    render json: { candidates: referrals }
  end

  def candidate_params
    params.permit(:name, :experience_years, :stack, :cv_url, :cv_key, :user_id)
  end

  def set_candidate_params(options = {})
    params[:user_id] = @current_user.id
    params
  end

  def user_permission_for_candidate?(candidate)
    @current_user.role == ADMIN_USER_ROLE || @current_user.role == MAINTAINER_USER_ROLE || candidate.user_id == @current_user.id
  end
end
