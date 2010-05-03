class TournamentCategory < ActiveRecord::Base
  has_many :tournament_players
 
end
