class PlayersPlayoff < ActiveRecord::Base
 belongs_to :divisional_game
 
 belongs_to :tournament_player,
   :foreign_key => 'player',  :class_name => 'TournamentPlayer'
 belongs_to :tournament_player,
   :foreign_key => 'opponent',  :class_name => 'TournamentPlayer'
   
end
