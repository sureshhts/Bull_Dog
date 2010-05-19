class LeagueScheduleGame < ActiveRecord::Base
  belongs_to :tournament_division_league_schedule
  belongs_to :winner, :class_name => "TournamentPlayer", :foreign_key => 'winner'
  belongs_to :loser, :class_name => "TournamentPlayer", :foreign_key => 'loser'
  has_many :league_game_players
  has_many :tournament_players, :through => :league_game_players
end