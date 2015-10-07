class Sweep < ActiveRecord::Base
  has_many :results
  has_many :devices, through: :results
  accepts_nested_attributes_for :devices
   self.per_page = 10
end
