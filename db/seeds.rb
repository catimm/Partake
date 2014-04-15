# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'active_record/fixtures'

# load test fixtures into DB for development and test so we can quickly start with some test data
if Rails.env.development? || Rails.env.test? || Rails.env.staging?
  ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "users")
  ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "venues")
  ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "packages")
  ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "package_instances")
  ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "events")
  ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "event_package_user_choices")
  ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "event_time_user_choices")
  ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "finalized_events")
  ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "invitees")
  ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "event_package_options")
  ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "event_time_options")
end