class TournamentDivision < ActiveRecord::Base
 belongs_to :tournament
 has_many :tournament_player
 has_many :tournament_division_league_schedules
 has_many :facilties_tournament_division
 has_many :facilties, :through => :faciltity_tournament_division
end
