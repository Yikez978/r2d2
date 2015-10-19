class CreateLeases < ActiveRecord::Migration
  def change
    create_table :leases do |t|
      t.string :mac
      t.string :ip
      t.string :mask
      t.string :expiration
      t.string :type
      t.string :name

      t.timestamps null: false
    end
  end
end
