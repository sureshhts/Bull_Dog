class TournamentDivisionLeagueSchedule < ActiveRecord::Base
  belongs_to :tournament_division
  has_many :league_schedule_games
end