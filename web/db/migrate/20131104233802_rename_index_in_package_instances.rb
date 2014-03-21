class RenameIndexInPackageInstances < ActiveRecord::Migration
  def change
    rename_index :package_instances, 'index_package_parameters_on_package_id', 'index_package_instances_on_package_id'
  end
end
