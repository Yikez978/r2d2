class AddFingerprintToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :fingerprint, :integer
  end
end
