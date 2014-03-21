class RenameEventPackageUserChoiceToResponse < ActiveRecord::Migration
  def up
    rename_table :event_package_user_choices, :responses
  end

  def down
    rename_table :responses, :event_package_user_choices
  end
end
