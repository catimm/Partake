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

require 'spec_helper'

describe PackageResponse do
  pending "add some examples to (or delete) #{__FILE__}"
end
