class CreateLovs < ActiveRecord::Migration[7.0]
  def change
    create_table :lovs do |t|
      t.string :category
      t.string :value
      t.string :name

      t.timestamps
    end
  end
end
