class CreateScopes < ActiveRecord::Migration
  def change
    create_table :scopes do |t|
      t.string :ip
      t.string :mask
      t.string :leasetime
      t.string :description
      t.string :comment
      t.string :state

      t.timestamps null: false
    end
  end
end
