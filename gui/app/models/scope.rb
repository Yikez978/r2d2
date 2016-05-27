class Scope < ActiveRecord::Base
  require 'resolv'
  validates :ip, presence: true,
                 uniqueness: true,
                 :format => { :with => Resolv::IPv4::Regex }
  validates :mask, presence: true,
                   :format => { :with => Resolv::IPv4::Regex }
  has_many :leases
  belongs_to :server
  accepts_nested_attributes_for :leases
  self.per_page = 10
end
