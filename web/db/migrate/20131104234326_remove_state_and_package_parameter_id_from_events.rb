class RemoveStateAndPackageParameterIdFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :state
    remove_column :events, :package_parameter_id
  end

  def down
    add_column :events, :state, :string
    add_column :events, :package_parameter_id, :integer
    add_index :events, :package_parameter_id, :name => "index_events_on_package_parameter_id"
  end
end
