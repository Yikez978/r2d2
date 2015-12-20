class Result < ActiveRecord::Base
  belongs_to :node
  belongs_to :sweep
end
