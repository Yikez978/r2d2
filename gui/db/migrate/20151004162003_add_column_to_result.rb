class AddColumnToResult < ActiveRecord::Migration
  def change
    add_column :results, :device_id, :integer
    add_column :results, :sweep_id, :integer
  end
end
