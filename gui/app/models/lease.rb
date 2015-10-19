class Lease < ActiveRecord::Base
   VALID_MAC_REGEX = /\A[\da-f]{2}:[\da-f]{2}:[\da-f]{2}:[\da-f]{2}:[\da-f]{2}:[\da-f]{2}\z/i
   validates :ip, presence: true
   validates :mac, presence: true,
                   format: { with: VALID_MAC_REGEX }
  belongs_to :scope
  self.per_page = 10
end
