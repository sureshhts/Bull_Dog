class KnockoutGamePlayer < ActiveRecord::Base
  belongs_to :tournament_player
  belongs_to :knockout_game
end