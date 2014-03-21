class CreateEventPackageChoices < ActiveRecord::Migration
  def change
    create_table :event_package_choices do |t|
      t.references :user
      t.references :event
      t.references :package

      t.timestamps
    end
    add_index :event_package_choices, :user_id
    add_index :event_package_choices, :event_id
    add_index :event_package_choices, :package_id
  end
end
