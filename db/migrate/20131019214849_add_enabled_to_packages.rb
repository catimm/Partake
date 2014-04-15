class AddEnabledToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :enabled, :boolean
  end
end
