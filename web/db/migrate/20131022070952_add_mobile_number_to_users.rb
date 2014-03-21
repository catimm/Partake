class AddMobileNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mobile_number, :integer, :limit => 8
    add_index :users, :mobile_number
  end
end
