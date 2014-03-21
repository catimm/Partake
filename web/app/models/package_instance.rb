# == Schema Information
#
# Table name: package_instances
#
#  id                   :integer          not null, primary key
#  package_id           :integer
#  available_start_time :time
#  available_end_time   :time
#  price                :integer
#  min_people           :integer
#  max_people           :integer
#  max_available        :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  cancel_notice        :string(255)
#  available_days       :string(255)
#  advance_notice       :string(255)
#
# Indexes
#
#  index_package_instances_on_package_id  (package_id)
#

class PackageInstance < ActiveRecord::Base
  belongs_to :package
  attr_accessible :advance_notice, :available_end_time, :available_start_time, :max_available, :max_people, :min_people, :price
  
  has_many :package_responses

end
