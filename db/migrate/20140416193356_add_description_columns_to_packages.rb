class AddDescriptionColumnsToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :description2, :text
    add_column :packages, :description3, :text
    add_column :packages, :description4, :text
  end
end
