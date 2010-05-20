class TournamentDivision < ActiveRecord::Base
 belongs_to :tournament
 has_many :tournament_player
 has_many :tournament_division_league_schedules
 has_many :facilties_tournament_division
 has_many :facilties, :through => :faciltity_tournament_division

  def self.division_with_max_players(tournament_id, player_id, category_id)
    query = %Q{ select td.id, count(tp.id) as players
                from tournament_divisions td
                join tournament_players tp on tp.tournament_division_id = td.id
                where tp.tournament_id = #{tournament_id} and tp.player_level_id = #{player_id} and tp.tournament_category_id = #{category_id}
                group by td.id
                order by players desc
                limit 1}
    result = find_by_sql(query)[0]
    return result.players
  end
end
