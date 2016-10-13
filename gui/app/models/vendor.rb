class Vendor < ActiveRecord::Base
  VALID_OUI_REGEX = /\A[\da-f]{6}\z/
  validates :name, presence: true
  validates :oui, presence: true,
                  format: { with: VALID_OUI_REGEX }
end
