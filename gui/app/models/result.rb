class Result < ActiveRecord::Base
  belongs_to :device
  belongs_to :sweep
end
