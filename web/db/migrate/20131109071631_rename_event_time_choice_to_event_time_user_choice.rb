class RenameEventTimeChoiceToEventTimeUserChoice < ActiveRecord::Migration
  def change
    rename_table :event_time_choices, :event_time_user_choices
  end
end
