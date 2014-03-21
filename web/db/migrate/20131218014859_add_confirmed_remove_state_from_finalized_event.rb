class AddConfirmedRemoveStateFromFinalizedEvent < ActiveRecord::Migration
  def up
    add_column :finalized_events, :confirmed, :boolean
    remove_column :finalized_events, :state
  end

  def down
    remove_column :finalized_events, :confirmed
    add_column :finalized_events, :state, :string
  end 
end
