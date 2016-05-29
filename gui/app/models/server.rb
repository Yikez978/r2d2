class Server < ActiveRecord::Base
  require 'resolv'
  validates :name, presence: true,
                   uniqueness: true
  validates :ip, presence: true,
                 uniqueness: true,
                 format: { :with => Resolv::IPv4::Regex }
  has_many :scopes
  accepts_nested_attributes_for :scopes
  self.per_page = 10
end
