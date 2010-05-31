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

  def self.tournament_players_league_standings(tournament)
    query = %Q{ select tp.id, concat(ap.first_name,' ',ap.last_name) as name, ap.contact_number, ap.email_address, tp.points, tp.knockout, tp.user_id
                from tournament_players tp
                join users u on u.id = tp.user_id
                join account_profiles ap on u.id = ap.user_id
                where tp.tournament_id = #{tournament}
                order by points desc }
    find_by_sql(query)
  end

  def self.available_knockout_non_selected_player(tournament, points)
    query = %Q{ select tp.id
                from tournament_players tp
                join users u on u.id = tp.user_id
                join account_profiles ap on u.id = ap.user_id
                where tp.tournament_id = #{tournament} and tp.knockout = '0' and tp.points < #{points}
                order by points desc
                limit 1}
    return TournamentPlayer.find(find_by_sql(query)[0].id)
  end
end
