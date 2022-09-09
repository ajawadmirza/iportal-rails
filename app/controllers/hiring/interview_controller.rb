class Hiring::InterviewController < ApplicationController
    before_action :is_activated?
    before_action :is_maintainer?, except: :for_self_user

    def index
        @interviews = []
        Interview.all.each_entry{ |interview| @interviews << interview&.with_feedback_and_interviewers}
        render json: { interviews: @interviews }
    end

    def create
        begin
            params[:candidate] = Candidate.find(params[:candidate_id].to_i).id
            interview = Interview.new(interview_params)
            interview.users = User.where(:id => params[:interviewers], :activated => true)
            save_object(interview)
        rescue => e
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def destroy
        begin
            interview = Interview.find(params[:interview_id].to_i)
            delete_object(interview)
        rescue => e
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def add_interviewers
        begin
            interview = Interview.find(params[:interview_id].to_i)
            interview.users = User.where(:id => params[:interviewers], :activated => true)
            if interview.save
                render json: interview.with_feedback_and_interviewers, status: :ok
            else
                render json: { error: interview.errors.full_messages }, status: :unprocessable_entity
            end
        rescue => e
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def for_self_user
        render_interviews_by_user(@current_user)
    end

    def for_query_user
        render_interviews_by_user(User.where(:id => params[:user_id]).limit(1).first)
    end

    private

    def render_interviews_by_user(user)
        user_interviews = []
        user&.interviews&.each_entry{ |interview| user_interviews << interview&.with_feedback_interviewers_and_candidate }
        render json: { interviews: user_interviews }
    end

    def interview_params
        params.permit(:scheduled_time, :location, :url, :user_ids, :candidate_id)
    end
end