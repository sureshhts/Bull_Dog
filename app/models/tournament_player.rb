class TournamentPlayer < ActiveRecord::Base
 belongs_to :user
 belongs_to :tournament
 belongs_to :tournament_category
 belongs_to :player_level
 belongs_to :tournament_division
 has_many :winners, :class_name => 'LeagueScheduleGame', :foreign_key => 'winner'
 has_many :losers, :class_name => 'LeagueScheduleGame', :foreign_key => 'loser'
 has_many :league_game_players
 has_many :league_schedule_games, :through => :league_game_players
end
