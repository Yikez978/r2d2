class Server < ActiveRecord::Base
  validates :name, presence: true,
                   uniqueness: true
  validates :ip, presence: true,
                 uniqueness: true
  has_many :scopes
  accepts_nested_attributes_for :scopes
  self.per_page = 10
end
