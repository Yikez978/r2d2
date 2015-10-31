class RemoveIpFromDevice < ActiveRecord::Migration
  def change
    remove_column :devices, :ip, :string
  end
end
