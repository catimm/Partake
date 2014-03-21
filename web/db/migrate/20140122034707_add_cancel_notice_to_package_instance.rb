class AddCancelNoticeToPackageInstance < ActiveRecord::Migration
  def change
    add_column :package_instances, :cancel_notice, :string
    add_column :package_instances, :available_days, :string
  end
end
