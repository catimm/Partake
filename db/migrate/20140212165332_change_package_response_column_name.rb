class ChangePackageResponseColumnName < ActiveRecord::Migration
  def self.up
    rename_column :package_responses, :package_id, :package_instance_id
  end

  def self.down
    rename_column :package_responses, :package_instance_id, :package_id
  end
end
