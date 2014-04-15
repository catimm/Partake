# == Schema Information
#
# Table name: friends
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  source     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Friend < ActiveRecord::Base
  belongs_to :user
  attr_accessible :friend_id, :source, :user_id
end
