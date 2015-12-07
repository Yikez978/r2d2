class List < ActiveRecord::Base
  self.per_page = 10
  before_validation :default_values
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false }
  validates :glyph,
            inclusion: { in: %w(
              glyphicon-unchecked
              glyphicon-thumbs-up
              glyphicon-thumbs-down
              glyphicon-warning-sign
              glyphicon-star
              glyphicon-eye-open ),
    message: "%{value} is not a valid glyph" }  

  def default_values
    self.glyph ||= 'glyphicon-warning-sign'
  end
end
