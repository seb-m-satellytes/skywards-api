class ChangeQuantityDefaultOnResources < ActiveRecord::Migration[7.1]
  def change
    change_column_default :resources, :amount, from: nil, to: 0
  end
end
