class ChangeGlyphInList < ActiveRecord::Migration
  def change
    remove_column :lists, :glyph
    add_reference :lists, :glyph, index: true, foreign_key: true
  end
end
