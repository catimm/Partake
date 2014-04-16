class CreateCommons < ActiveRecord::Migration
  def change
    create_table :commons do |t|
      t.integer :user_id
      t.integer :friend_id
      t.integer :package_instance_id

      t.timestamps
    end
  end
end
