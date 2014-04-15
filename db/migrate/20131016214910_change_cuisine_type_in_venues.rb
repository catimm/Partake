class ChangeCuisineTypeInVenues < ActiveRecord::Migration
  def up
    change_column :venues, :cuisine, :string
  end

  def down
    change_column :venues, :cuisine, :integer
  end
end
