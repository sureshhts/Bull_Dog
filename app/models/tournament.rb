class Tournament < ActiveRecord::Base
 has_many :tournament_players
 has_many :tournament_divisions 
end
