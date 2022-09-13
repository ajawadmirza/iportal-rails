class Hiring::InterviewController < ApplicationController
  before_action :is_activated?
  before_action :is_maintainer?, except: :for_self_user

  def index
    @interviews = []
    Interview.filter(interview_filter_params).each_entry { |interview| @interviews << interview&.with_feedback_and_interviewers }
    render json: { interviews: @interviews }
  end

  def show
    safe_operation do
      interview = Interview.filter_by_id(params[:id]).limit(1).first
      render json: interview&.with_feedback_interviewers_and_candidate
    end
  end

  def create
    safe_operation do
      params[:candidate] = Candidate.find(params[:candidate_id].to_i).id
      interview = Interview.new(interview_params)
      interviewers = User.having_id_and_activated(params[:interviewers])
      interview.users = interviewers unless interviewers&.empty?
      if save_object(interview)
        notify_interviewers(interviewers, interview)
      end
    end
  end

  def update
    safe_operation do
      interview = Interview.find(params[:id])
      interviewers = User.having_id_and_activated(params[:interviewers] || [])
      interview.users = interviewers unless interviewers&.empty?
      if update_object(interview, interview_params.except(:candidate_id))
        notify_interviewers(interviewers, interview)
      end
    end
  end

  def destroy
    safe_operation do
      interview = Interview.find(params[:interview_id])
      delete_object(interview)
    end
  end

  def add_interviewers
    safe_operation do
      interview = Interview.find(params[:interview_id].to_i)
      interviewers = User.having_id_and_activated(params[:interviewers] || [])
      interview.users = interviewers unless interviewers&.empty?
      if interview.save
        render json: interview.with_feedback_and_interviewers, status: :ok
        notify_interviewers(interviewers, interview)
      else
        render json: { error: interview.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def for_self_user
    render_interviews_by_user(@current_user)
  end

  def for_query_user
    render_interviews_by_user(User.filter_by_id(params[:user_id]).limit(1).first)
  end

  private

  def interview_filter_params
    params.slice(:id, :scheduled_time, :location, :url, :has_feedback, :total_interviewers, :till, :from)
  end

  def render_interviews_by_user(user)
    user_interviews = []
    interviews = filter_records(user&.interviews, interview_filter_params)
    interviews&.each_entry { |interview| user_interviews << interview&.with_feedback_interviewers_and_candidate }
    render json: { interviews: user_interviews }
  end

  def interview_params
    params.permit(:scheduled_time, :location, :url, :user_ids, :candidate_id)
  end

  def notify_interviewers(interviewers, interview)
    interviewers.each_entry do |interviewer|
        NotificationMailer.send_interview_notification_mail_to_interviewers(interviewer, interview&.with_interviewers_and_candidate, @current_user).deliver_later!
    end
  end
end
