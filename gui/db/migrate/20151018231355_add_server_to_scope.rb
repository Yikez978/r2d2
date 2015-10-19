class AddServerToScope < ActiveRecord::Migration
  def change
    add_reference :scopes, :server, index: true, foreign_key: true
  end
end
