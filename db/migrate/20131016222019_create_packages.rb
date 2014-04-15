class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.references :venue
      t.string :type
      t.text :description

      t.timestamps
    end
    add_index :packages, :venue_id
  end
end
