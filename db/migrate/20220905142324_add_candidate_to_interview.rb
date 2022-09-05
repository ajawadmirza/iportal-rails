class AddCandidateToInterview < ActiveRecord::Migration[7.0]
  def change
    add_column :interviews, :candidate_id, :integer
    add_index  :interviews, :candidate_id
  end
end
