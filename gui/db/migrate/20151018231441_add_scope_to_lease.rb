class AddScopeToLease < ActiveRecord::Migration
  def change
    add_reference :leases, :scope, index: true, foreign_key: true
  end
end
