class RenameUrlToUidInInvitees < ActiveRecord::Migration
  def change
    rename_column :invitees, :url, :uid
  end
end
