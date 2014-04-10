# == Schema Information
#
# Table name: commons
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  friend_id           :integer
#  package_instance_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Common < ActiveRecord::Base
  belongs_to :user
  attr_accessible :friend_id, :package_instance_id, :user_id
end
