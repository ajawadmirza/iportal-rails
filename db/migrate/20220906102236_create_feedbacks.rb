class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.string :status
      t.string :remarks
      t.string :file_url
      t.string :file_key

      t.timestamps
    end
  end
end
