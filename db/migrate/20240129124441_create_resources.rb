class CreateResources < ActiveRecord::Migration[7.1]
  def change
    create_table :resources do |t|
      t.string :type
      t.integer :amount
      t.string :resourceable_type
      t.integer :resourceable_id 
      t.timestamps
    end
  end
end
