class CreateFbFriends < ActiveRecord::Migration
  def change
    create_table :fb_friends do |t|
      t.integer :user_id
      t.string :friend_name
      t.integer :friend_fbid

      t.timestamps
    end
  end
end
