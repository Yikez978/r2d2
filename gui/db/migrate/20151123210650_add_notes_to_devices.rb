class AddNotesToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :notes, :string
  end
end
