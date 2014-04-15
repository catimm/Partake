class CreatePackageParameters < ActiveRecord::Migration
  def change
    create_table :package_parameters do |t|
      t.references :package
      t.time :available_start_time
      t.time :available_end_time
      t.integer :price
      t.integer :advance_notice
      t.integer :min_people
      t.integer :max_people
      t.integer :max_available

      t.timestamps
    end
    add_index :package_parameters, :package_id
  end
end
