class AddResponseToEventPackageUserChoice < ActiveRecord::Migration
  def change
    add_column :event_package_user_choices, :response, :boolean
  end
end
