# == Schema Information
#
# Table name: contacts
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  friend_name  :string(255)
#  friend_email :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Contact < ActiveRecord::Base
  belongs_to :user
  attr_accessible :friend_email, :friend_name, :user_id
end
