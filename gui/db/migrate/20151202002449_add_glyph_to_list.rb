class AddGlyphToList < ActiveRecord::Migration
  def change
    add_column :lists, :glyph, :string
  end
end
