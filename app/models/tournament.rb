class Tournament < ActiveRecord::Base
 has_many :tournament_players
 has_many :tournament_divisions
 has_many :tournament_category_mappings
 has_many :tournament_categories, :through => :tournament_category_mappings

 def self.tournaments_for_registration(user)
   query1 = %Q{ SELECT *
                FROM tournaments t
                where t.registration_starts < #{Time.now.to_i} and t.registration_ends > #{Time.now.to_i}}
   available_tournaments = find_by_sql(query1)
   user_tournaments = User.find(user).tournament_players.collect{|rec| rec.tournament_id}
   applicable_tournaments = Array.new

   for tour in available_tournaments
     if !user_tournaments.include?(tour.id)
       applicable_tournaments.push(tour)
     end
   end
   return applicable_tournaments
 end

 def self.tournament_summary
   query = %Q{  select t.id, t.name, t.registration_starts, t.registration_ends, t.tournament_type, count(tp.tournament_id) as players
                from tournaments t
                left outer join tournament_players tp on t.id = tp.tournament_id
                group by t.id  }
   find_by_sql(query)
 end

 def self.list_of_tournament_players(tournament_id)
   query = %Q{  SELECT tp.id as player_id, acp.user_id as user_id, concat(acp.first_name,' ',acp.last_name) as name, tc.name as category_name, pl.name as player_level, f.name as facility_name
                from tournaments t
                join tournament_players tp on tp.tournament_id = t.id
                join account_profiles acp on acp.user_id = tp.user_id
                join tournament_categories tc on tc.id = tp.tournament_category_id
                join player_levels pl on pl.id = tp.player_level_id
                join account_playing_details apd on apd.user_id = tp.user_id
                join facilities f on f.id = apd.facility_id
                where t.id = #{tournament_id} }
    find_by_sql(query)
 end

 def self.tournament_players_summary(tournament_id, sort)
   query = %Q{  SELECT tp.id as player_id, acp.user_id as user_id, concat(acp.first_name,' ',acp.last_name) as name, tc.name as category_name, pl.name as player_level, f.name as facility_name
                from tournaments t
                join tournament_players tp on tp.tournament_id = t.id
                join account_profiles acp on acp.user_id = tp.user_id
                join tournament_categories tc on tc.id = tp.tournament_category_id
                join player_levels pl on pl.id = tp.player_level_id
                join account_playing_details apd on apd.user_id = tp.user_id
                join facilities f on f.id = apd.facility_id
                where t.id = #{tournament_id}
                order by #{sort}}
    find_by_sql(query)
 end

 def tournament_divisions
   query = %Q{  SELECT d.id, d.name, d.no_of_players, f.name as facility
                from tournaments t
                join tournament_divisions d on d.tournament_id = t.id
                join facilities_tournament_divisions ftd on ftd.tournament_division_id = d.id
                join facilities f on f.id = ftd.facility_id
                where t.id = #{@id} }

   find_by_sql(query)
 end
end
