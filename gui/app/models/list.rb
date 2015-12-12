class List < ActiveRecord::Base
  belongs_to :glyph
  self.per_page = 10
  before_validation :default_values
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false }
  def default_values
    self.glyph_id ||= Glyph.find_by_name('glyphicon-warning-sign').id
  end
end
