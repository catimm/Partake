class AddContactEmailAndContactPhoneToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :contact_email, :string
    add_column :venues, :contact_phone, :integer
  end
end
