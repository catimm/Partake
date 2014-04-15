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

require 'spec_helper'

describe Contact do
  pending "add some examples to (or delete) #{__FILE__}"
end
