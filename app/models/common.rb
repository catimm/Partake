class Common < ActiveRecord::Base
  belongs_to :user
  attr_accessible :friend_id, :package_instance_id, :user_id
end
