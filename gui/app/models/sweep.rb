class Sweep < ActiveRecord::Base
  has_many :results
  has_many :nodes, through: :results
  accepts_nested_attributes_for :nodes
  self.per_page = 10
  validates :description, presence: true
end
