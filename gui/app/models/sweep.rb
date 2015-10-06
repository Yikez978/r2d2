class Sweep < ActiveRecord::Base
  has_many :results
  has_many :devices, through: :results
  self.per_page = 10
end
