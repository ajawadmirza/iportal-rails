class CreateCandidates < ActiveRecord::Migration[7.0]
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :cv_url
      t.string :cv_key
      t.string :stack
      t.string :experience_years

      t.timestamps
    end
  end
end
