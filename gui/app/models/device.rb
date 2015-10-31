class Device < ActiveRecord::Base
  has_many :results
  has_many :sweeps, through: :results
  self.per_page = 10
  VALID_MAC_REGEX = /\A[\da-f]{2}:[\da-f]{2}:[\da-f]{2}:[\da-f]{2}:[\da-f]{2}:[\da-f]{2}\z/i
  validates :mac, presence: true,
                  format: { with: VALID_MAC_REGEX },
                  uniqueness: true
  validates :status, inclusion: { in: [nil, 'W', 'B'] }
end
