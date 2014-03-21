class CreatePackageResponses < ActiveRecord::Migration
  def change
    create_table :package_responses do |t|
      t.integer :user_id
      t.integer :package_id
      t.boolean :response

      t.timestamps
    end
  end
end
