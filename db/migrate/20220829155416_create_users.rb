class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :role
      t.string :employee_id
      t.boolean :activated
      t.boolean :verified_email

      t.timestamps
    end
  end
end
