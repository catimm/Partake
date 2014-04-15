class RenamePackageParametersToPackageInstances < ActiveRecord::Migration
  def change
    rename_table :package_parameters, :package_instances
  end
end
