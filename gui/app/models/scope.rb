class Scope < ActiveRecord::Base
  validates :ip, presence: true,
                 uniqueness: true
  has_many :leases
  belongs_to :server
  accepts_nested_attributes_for :leases
  self.per_page = 10
end
