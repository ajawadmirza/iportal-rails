class Hiring::InterviewController < ApplicationController
    before_action :is_activated?
    before_action :is_maintainer?

    def index
        all_interviews = { interviews: [] }
        Interview.all.each do |interview|
            interview_obj = interview.with_feedback_and_interviewers
            all_interviews[:interviews] << interview_obj
        end
        render json: all_interviews
    end

    def create
        begin
            params[:candidate] = Candidate.find(params[:candidate_id].to_i).id
            interview = Interview.new(interview_params)
            interview.users = User.where(:id => params[:interviewers])
            if interview.save
                render json: interview
            else
                render json: { errors: interview.errors.full_messages }, status: :unprocessable_entity
            end
        rescue => e
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def destroy
        begin
            interview = Interview.find(params[:interview_id].to_i)
            result = interview.destroy
            if result
                render json: { message: 'interview is successfully deleted' }, status: :ok
            else
                render json: { errors: interview.errors.full_messages }, status: :unprocessable_entity
            end
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

    private

    def interview_params
        params.permit(:scheduled_time, :location, :url, :user_ids, :candidate_id)
    end
end