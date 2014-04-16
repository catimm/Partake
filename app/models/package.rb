# == Schema Information
#
# Table name: packages
#
#  id           :integer          not null, primary key
#  venue_id     :integer
#  package_type :string(255)
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  enabled      :boolean
#  title        :string(255)
#  image_url    :string(255)
#  description2 :text
#  description3 :text
#  description4 :text
#
# Indexes
#
#  index_packages_on_venue_id  (venue_id)
#

class Package < ActiveRecord::Base
  belongs_to :venue
  has_many :package_instances
  attr_accessible :description, :package_type
end
