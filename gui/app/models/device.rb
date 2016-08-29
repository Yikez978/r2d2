class Device < ActiveRecord::Base
  belongs_to :list
  before_validation :default_values
  self.per_page = 10
  VALID_MAC_REGEX = /\A[\da-f]{2}:[\da-f]{2}:[\da-f]{2}:[\da-f]{2}:[\da-f]{2}:[\da-f]{2}\z/i
  validates :mac, presence: true,
                  format: { with: VALID_MAC_REGEX },
                  uniqueness: true
#  validates :list, presence: true
  def default_values
    self.list_id ||= List.find_by_name('Unassigned').id
  end
end
