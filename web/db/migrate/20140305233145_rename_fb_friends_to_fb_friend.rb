class RenameFbFriendsToFbFriend < ActiveRecord::Migration
  def up
    rename_table :fb_friends, :something
  end

  def down
    rename_table :something, :fb_friends
  end
end
