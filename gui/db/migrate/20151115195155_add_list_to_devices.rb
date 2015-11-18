class AddListToDevices < ActiveRecord::Migration
  def change
    add_reference :devices, :list, index: true, foreign_key: true
    change_table :devices do |t|
      t.remove :status
    end
  end
end