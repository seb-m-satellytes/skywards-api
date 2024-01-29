class AddSettlementRefToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_reference :characters, :settlement, null: false, foreign_key: true
  end
end
