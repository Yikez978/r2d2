class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :oui
      t.string :name

      t.timestamps null: false
    end
  end
end
