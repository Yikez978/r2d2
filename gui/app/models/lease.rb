class Lease < ActiveRecord::Base
  require 'resolv'
  validates :ip, presence: true,
                 format: { :with => Resolv::IPv4::Regex }
  validates :device, presence: true
  validates :expiration, presence: true
  belongs_to :scope
  belongs_to :device
  accepts_nested_attributes_for :device
  self.per_page = 10
end
