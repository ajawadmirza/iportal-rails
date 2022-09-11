class Common::QuestionController < ApplicationController
  before_action :is_activated?

  def index
    @questions = []
    Question.filter(question_filter_params).each_entry { |question| @questions << question&.response_hash }
    render json: { questions: @questions }
  end

  def create
    safe_operation do
      params[:user_id] = @current_user.id
      question = Question.new(question_params)
      save_object(question)
    end
  end

  def update
    safe_operation do
      question = Question.find(params[:id])
      permission = user_permission_for_question?(question)
      perform_if_permitted(permission) { update_object(question, question_params.except(:user_id)) }
    end
  end

  def destroy
    safe_operation do
      question = Question.find(params[:id])
      permission = user_permission_for_question?(question)
      perform_if_permitted(permission) { delete_object(question) }
    end
  end

  def posted_by_self_user
    render_questions_for_user(@current_user.id)
  end

  def posted_by_query_user
    render_questions_for_user(params[:user_id])
  end

  private

  def question_filter_params
    params.slice(:id, :course, :description, :answer, :priority, :posted_by)
  end

  def question_params
    params.permit(:course, :description, :answer, :priority, :user_id)
  end

  def user_permission_for_question?(question)
    @current_user.role == ADMIN_USER_ROLE || @current_user.role == MAINTAINER_USER_ROLE || question.user_id == @current_user.id
  end

  def render_questions_for_user(user_id)
    user_questions = []
    questions = Question.filter(question_filter_params).filter_by_posted_by(user_id)
    questions.each_entry { |question| user_questions << question&.response_hash }
    render json: { questions: user_questions }
  end
end
