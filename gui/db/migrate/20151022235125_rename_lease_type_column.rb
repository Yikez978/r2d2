class RenameLeaseTypeColumn < ActiveRecord::Migration
  def change
    rename_column :leases, :type, :kind
  end
end
