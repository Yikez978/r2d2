class CreateSweepers < ActiveRecord::Migration
  def change
    create_table :sweepers do |t|
      t.string :ip
      t.string :mac
      t.string :description

      t.timestamps null: false
    end
  end
end
