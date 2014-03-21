class RemoveTimestampFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :timestamp
  end

  def down
    add_column :events, :timestamp, :datetime
  end
end
