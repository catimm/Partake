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

require 'spec_helper'

describe FbFriend do
  pending "add some examples to (or delete) #{__FILE__}"
end
