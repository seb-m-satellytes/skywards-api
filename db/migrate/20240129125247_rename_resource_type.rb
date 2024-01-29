class RenameResourceType < ActiveRecord::Migration[7.1]
  def change
    rename_column :resources, :type, :resource_type
  end
end
