class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.integer :cuisine
      t.integer :phone
      t.string :website
      t.string :facebook
      t.string :street
      t.string :city
      t.string :state
      t.integer :zip
      t.string :hours1
      t.string :hours2
      t.string :hours3
      t.string :hours4
      t.string :contact_first_name
      t.string :contact_last_name
      t.string :contact_role

      t.timestamps
    end
  end
end
