class AddQuestionToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :user_id, :integer
    add_index  :questions, :user_id
  end
end
