class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :mac
      t.string :ip

      t.timestamps null: false
    end
  end
end
