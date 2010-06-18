class TournamentPlayer < ActiveRecord::Base
 belongs_to :user
 belongs_to :tournament
 belongs_to :tournament_category
 belongs_to :player_level
 belongs_to :tournament_division
 has_many :winners, :class_name => 'LeagueScheduleGame', :foreign_key => 'winner'
 has_many :losers, :class_name => 'LeagueScheduleGame', :foreign_key => 'loser'
 has_many :knockout_winners, :class_name => 'KnockoutGame', :foreign_key => 'winner'
 has_many :knockout_losers, :class_name => 'KnockoutGame', :foreign_key => 'loser'
 has_many :league_game_players
 has_many :league_schedule_games, :through => :league_game_players
 has_many :knockout_game_players
 has_many :knockout_games, :through => :knockout_game_players

  def self.tournament_players_league_standings(tournament)
    query = %Q{ select tp.id, concat(ap.first_name,' ',ap.last_name) as name, ap.contact_number, ap.email_address, tp.points, tp.knockout, tp.user_id
                from tournament_players tp
                join users u on u.id = tp.user_id
                join account_profiles ap on u.id = ap.user_id
                where tp.tournament_id = #{tournament}
                order by points desc }
    find_by_sql(query)
  end

  def self.tournament_players_level_standings(tournament, level)
    query = %Q{ select tp.id, concat(ap.first_name,' ',ap.last_name) as name, ap.contact_number, ap.email_address, tp.points, tp.knockout, tp.user_id
                from tournament_players tp
                join users u on u.id = tp.user_id
                join account_profiles ap on u.id = ap.user_id
                where tp.tournament_id = #{tournament} and player_level_id = #{level}
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

  def self.player_history(player)
    query = %Q{ select tp.id, t.name, pl.name as level, tc.name as category, tp.points
                from tournament_players tp
                join tournaments t on t.id = tp.tournament_id
                join player_levels pl on pl.id = tp.player_level_id
                join tournament_categories tc on tc.id = tp.tournament_category_id
                where tp.user_id = #{player}}
    find_by_sql(query)
  end
end
