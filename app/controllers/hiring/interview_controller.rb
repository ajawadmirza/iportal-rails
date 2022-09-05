class Hiring::InterviewController < ApplicationController
    before_action :is_activated?
    before_action :is_maintainer?

    def index
        all_interviews = { interviews: [] }
        Interview.all.each do |interview|
            interview_obj = get_interview_with_users(interview)
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
            interview.users = User.where(:id => params[:interviewers])
            if interview.save
                render json: get_interview_with_users(interview), status: :ok
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

    def get_interview_with_users(interview)
        interviewers = []
        interview_obj = interview.attributes
        interview.users.each do |interviewer|
            user = {
                id: interviewer.id,
                email: interviewer.email,
                employee_id: interviewer.employee_id,
            }
        interviewers << user
        end
        interview_obj['interviewers'] = interviewers
        interview_obj
    end
end