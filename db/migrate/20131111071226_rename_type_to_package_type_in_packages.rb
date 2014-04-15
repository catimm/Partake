class RenameTypeToPackageTypeInPackages < ActiveRecord::Migration
  def up
    rename_column :packages, :type, :package_type
  end

  def down
    rename_column :packages, :package_type, :type
  end
end
