# == Schema Information
#
# Table name: package_responses
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  package_instance_id :integer
#  response            :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class PackageResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :package_instance
  attr_accessible :package_instance_id, :response, :user_id

  scope :complete, where(:user_id => :user)

  validates :user, :package_instance_id, :presence => true
  validates :response, :inclusion => { :in => [true, false] }
  
end
