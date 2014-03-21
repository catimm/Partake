class CreateEventTimeChoices < ActiveRecord::Migration
  def change
    create_table :event_time_choices do |t|
      t.references :user
      t.references :event
      t.datetime :timestamp
      t.string :response

      t.timestamps
    end
    add_index :event_time_choices, :user_id
    add_index :event_time_choices, :event_id
  end
end
