class AddDescriptionToSweeps < ActiveRecord::Migration
  def change
    add_column :sweeps, :description, :string
  end
end
