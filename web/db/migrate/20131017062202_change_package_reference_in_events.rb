class ChangePackageReferenceInEvents < ActiveRecord::Migration
  def up
    remove_column :events, :package_id
    add_column :events, :package_parameter_id, :integer
    add_index :events, :package_parameter_id
  end

  def down
    add_column :events, :package_id, :integer
    remove_column :events, :package_parameter_id
  end
end
