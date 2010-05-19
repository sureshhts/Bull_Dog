class LeagueGamePlayer < ActiveRecord::Base
  belongs_to :tournament_player
  belongs_to :league_schedule_game
end