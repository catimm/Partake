class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :package
      t.references :user
      t.integer :rating
      t.string :category
      t.text :comments

      t.timestamps
    end
    add_index :ratings, :package_id
    add_index :ratings, :user_id
  end
end
