class AddCandidateToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :user_id, :integer
    add_index  :candidates, :user_id
  end
end
