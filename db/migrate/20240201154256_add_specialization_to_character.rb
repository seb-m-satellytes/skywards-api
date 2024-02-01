class AddSpecializationToCharacter < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :specialization, :string
  end
end
