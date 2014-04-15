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

require 'test_helper'

class VenueTest < ActiveSupport::TestCase
  test "contact email should be valid" do
    v = Venue.new
    v.contact_email = "john@"
    assert_raise(ActiveRecord::RecordInvalid) do
      v.save!
    end

    v = Venue.new
    v.contact_email = "joe@blah.io"
    v.save!
  end

  test "contact email can be blank" do
    v = Venue.new
    v.save!
  end
end
