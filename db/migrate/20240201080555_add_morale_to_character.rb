class AddMoraleToCharacter < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :morale_status, :integer, default: 0
  end
end
