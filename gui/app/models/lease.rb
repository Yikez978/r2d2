class Lease < ActiveRecord::Base
  validates :ip, presence: true
  validates :device, presence: true
  validates :expiration, presence: true
  belongs_to :scope
  belongs_to :device
  self.per_page = 10
end
