class RenameEventPackageChoiceToEventPackageUserChoice < ActiveRecord::Migration
  def change
    rename_table :event_package_choices, :event_package_user_choices
  end
end
