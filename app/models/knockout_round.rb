class KnockoutRound < ActiveRecord::Base
  belongs_to :tournament  
  has_many :knockout_games
end