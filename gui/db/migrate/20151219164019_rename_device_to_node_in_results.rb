class RenameDeviceToNodeInResults < ActiveRecord::Migration
  def change
    rename_column :results, :device_id, :node_id
  end
end
