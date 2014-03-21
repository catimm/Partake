class AddImageUrlToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :image_url, :string
  end
end
