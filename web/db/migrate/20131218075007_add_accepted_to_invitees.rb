class AddAcceptedToInvitees < ActiveRecord::Migration
  def change
    add_column :invitees, :accepted, :boolean
  end
end
