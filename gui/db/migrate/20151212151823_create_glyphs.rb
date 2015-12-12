class CreateGlyphs < ActiveRecord::Migration
  def change
    create_table :glyphs do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
