# == Schema Information
#
# Table name: authentications
#
#  id           :integer          not null, primary key
#  user_id      :string(255)
#  provider     :string(255)
#  uid          :string(255)
#  token        :string(255)
#  token_secret :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Authentication do
  pending "add some examples to (or delete) #{__FILE__}"
end
