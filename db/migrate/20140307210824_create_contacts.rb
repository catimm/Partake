class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.string :friend_name
      t.string :friend_email

      t.timestamps
    end
  end
end
