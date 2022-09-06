class AddFeedbackToInterviewAndUser < ActiveRecord::Migration[7.0]
  def change
    add_column :feedbacks, :interview_id, :integer
    add_index  :feedbacks, :interview_id

    add_column :feedbacks, :user_id, :integer
    add_index  :feedbacks, :user_id
  end
end
