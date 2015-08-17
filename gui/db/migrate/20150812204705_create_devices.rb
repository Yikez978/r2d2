class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :mac
      t.string :ip

      t.timestamps null: false
    end
  end
end
