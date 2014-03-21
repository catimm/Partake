class AddNeighborhoodToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :neighborhood, :string
  end
end
