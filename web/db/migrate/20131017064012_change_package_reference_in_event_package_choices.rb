class ChangePackageReferenceInEventPackageChoices < ActiveRecord::Migration
  def up
    remove_column :event_package_choices, :package_id
    add_column :event_package_choices, :package_parameter_id, :integer
    add_index :event_package_choices, :package_parameter_id
  end

  def down
    add_column :event_package_choices, :package_id, :integer
    remove_column :event_package_choices, :package_parameter_id
  end
end
