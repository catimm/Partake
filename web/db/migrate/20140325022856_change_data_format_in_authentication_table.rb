class ChangeDataFormatInAuthenticationTable < ActiveRecord::Migration
  def up
    change_column :authentications, :user_id, 'integer USING CAST(user_id AS integer)'
  end

  def down
    change_column :authentications, :user_id, :string
  end
end
