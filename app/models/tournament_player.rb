class TournamentPlayer < ActiveRecord::Base
 belongs_to :user
 belongs_to :tournament
 belongs_to :tournament_category
 belongs_to :player_level
 belongs_to :tournament_division
  
 has_one :player,
   :foreign_key => 'player',  :class_name => 'player_playoff'
 has_one :player,
   :foreign_key => 'opponent',  :class_name => 'player_playoff'
   
end
