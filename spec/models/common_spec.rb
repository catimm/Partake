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

require 'spec_helper'

describe Common do
  pending "add some examples to (or delete) #{__FILE__}"
end
