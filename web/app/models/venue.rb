# == Schema Information
#
# Table name: venues
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  cuisine            :string(255)
#  phone              :integer
#  website            :string(255)
#  facebook           :string(255)
#  street             :string(255)
#  city               :string(255)
#  state              :string(255)
#  zip                :integer
#  hours1             :string(255)
#  hours2             :string(255)
#  hours3             :string(255)
#  hours4             :string(255)
#  contact_first_name :string(255)
#  contact_last_name  :string(255)
#  contact_role       :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  contact_email      :string(255)
#  contact_phone      :integer
#  neighborhood       :string(255)
#

class Venue < ActiveRecord::Base
  attr_accessible :city, :contact_first_name, :contact_last_name, :contact_role,
                  :cuisine, :facebook, :hours1, :hours2, :hours3, :hours4, :name,
                  :phone, :state, :street, :website, :zip, :contact_email, :contact_phone
  has_many :packages
  validates :contact_email, :format => { :with => Devise::email_regexp }, :if => :contact_email_changed?
end
