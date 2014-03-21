class ChangeReferencesForEventPackageUserChoice < ActiveRecord::Migration
  def up
    remove_column :event_package_user_choices, :package_parameter_id
    remove_column :event_package_user_choices, :event_id

    add_column :event_package_user_choices, :event_package_option_id, :integer
    add_index :event_package_user_choices, :event_package_option_id
  end

  def down
    add_column :event_package_user_choices, :package_parameter_id, :integer
    add_column :event_package_user_choices, :event_id, :integer

    add_index "event_package_user_choices", ["event_id"], :name => "index_event_package_choices_on_event_id"
    add_index "event_package_user_choices", ["package_parameter_id"], :name => "index_event_package_choices_on_package_parameter_id"   

    remove_column :event_package_user_choices, :event_package_option_id
  end
end
