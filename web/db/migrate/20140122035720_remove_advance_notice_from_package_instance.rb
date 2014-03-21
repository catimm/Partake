class RemoveAdvanceNoticeFromPackageInstance < ActiveRecord::Migration
  def up
    remove_column :package_instances, :advance_notice
  end

  def down
    add_column :package_instances, :advance_notice, :integer
  end
end
