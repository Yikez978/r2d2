class CreateSweeps < ActiveRecord::Migration
  def change
    create_table :sweeps do |t|

      t.timestamps null: false
    end
  end
end
