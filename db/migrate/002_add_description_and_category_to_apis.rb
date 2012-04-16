class AddDescriptionAndCategoryToApis < ActiveRecord::Migration
  def self.up
    add_column :apis, :description, :string
    add_column :apis, :category, :string
  end

  def self.down
    remove_column :apis, :description
    remove_column :apis, :category
  end
end