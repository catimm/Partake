class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :name
      t.string :email
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
