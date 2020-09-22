class AddStatusToCar < ActiveRecord::Migration[6.0]
  def change
    add_column :cars, :status, :integer, default: 0
  end
end
