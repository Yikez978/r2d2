class RemoveMacFromLease < ActiveRecord::Migration
  def change
    remove_column :leases, :mac, :string
  end
end
