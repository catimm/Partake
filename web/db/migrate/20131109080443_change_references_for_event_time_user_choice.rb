class ChangeReferencesForEventTimeUserChoice < ActiveRecord::Migration
  def up
    remove_column :event_time_user_choices, :timestamp
    remove_column :event_time_user_choices, :event_id
    # change_column :event_time_user_choices, :response, :boolean
    connection.execute(%q{
        alter table event_time_user_choices
        alter column response
        type boolean using response::boolean
    })

    add_column :event_time_user_choices, :event_time_option_id, :integer
    add_index :event_time_user_choices, :event_time_option_id
  end

  def down
    add_column :event_time_user_choices, :timestamp, :datetime
    add_column :event_time_user_choices, :event_id, :integer
    # change_column :event_time_user_choices, :response, :string
    connection.execute(%q{
        alter table event_time_user_choices
        alter column response
        type string using response::string
    })

    add_index "event_time_user_choices", ["event_id"], :name => "index_event_time_choices_on_event_id"

    remove_column :event_time_user_choices, :event_time_option_id
  end
end
