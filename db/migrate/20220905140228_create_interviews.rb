class CreateInterviews < ActiveRecord::Migration[7.0]
  def change
    create_table :interviews do |t|
      t.string :scheduled_time
      t.string :location
      t.string :url

      t.timestamps
    end

    create_table :interviews_users, id: false do |t|
      t.belongs_to :interview
      t.belongs_to :user
    end
  end
end
