# == Schema Information
#
# Table name: fb_friends
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  friend_name :string(255)
#  friend_fbid :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FbFriend < ActiveRecord::Base
  belongs_to :user
  attr_accessible :friend_fbid, :friend_name, :user_id
end
