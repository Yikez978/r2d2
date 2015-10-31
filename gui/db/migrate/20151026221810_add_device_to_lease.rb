class AddDeviceToLease < ActiveRecord::Migration
  def change
    add_reference :leases, :device, index: true, foreign_key: true
  end
end
