class AddAdvanceNoticeToPackageInstance < ActiveRecord::Migration
  def change
    add_column :package_instances, :advance_notice, :string
  end
end
