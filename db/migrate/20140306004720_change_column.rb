class ChangeColumn < ActiveRecord::Migration
  def up
    change_column :fb_friends, :friend_fbid, :bigint
  end

  def down
    change_column :fb_friends, :friend_fbid, :integer
  end
end
