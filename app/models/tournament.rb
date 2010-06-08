class Tournament < ActiveRecord::Base
 has_many :tournament_players
 has_many :tournament_divisions
 has_many :knockout_games
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
   query = %Q{  select t.id, t.name, t.registration_starts, t.registration_ends, t.tournament_type, count(tp.tournament_id) as players, t.knockout_selected
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

 def self.tournament_players_summary(tournament_id, sort, *conditions)
   condition = ""
   if !conditions[0].blank?
     condition = " and tc.id = #{conditions[0][0]} and pl.id = #{conditions[0][1]}"
   end
   query = %Q{  SELECT tp.id as player_id, acp.user_id as user_id, concat(acp.first_name,' ',acp.last_name) as name, tc.name as category_name, pl.name as player_level, f.name as facility_name, td.name as division_name
                from tournaments t
                join tournament_players tp on tp.tournament_id = t.id
                join account_profiles acp on acp.user_id = tp.user_id
                join tournament_categories tc on tc.id = tp.tournament_category_id
                join player_levels pl on pl.id = tp.player_level_id
                join account_playing_details apd on apd.user_id = tp.user_id
                join facilities f on f.id = apd.facility_id
                left outer join tournament_divisions td on td.id = tp.tournament_division_id
                where t.id = #{tournament_id} #{condition}
                order by #{sort}}
    find_by_sql(query)
 end

 def self.tournament_divisions(tournament_id, *conditions)
   condition = ""
   sort = ""
   if !conditions[0].blank?
     condition = " and tc.id = #{conditions[0][0]} and pl.id = #{conditions[0][1]}"
   end
   if !conditions[0][2].blank?
     sort = " order by #{conditions[0][2]}"
   end
   query = %Q{  SELECT d.id, d.name, d.no_of_players, f.name as facility, d.area_name, count(tp.id) as players, d.draw_created
                from tournaments t
                join tournament_divisions d on d.tournament_id = t.id
                join facilities_tournament_divisions ftd on ftd.tournament_division_id = d.id
                join facilities f on f.id = ftd.facility_id
                join tournament_categories tc on tc.id = d.tournament_category_id
                join player_levels pl on pl.id = d.player_level_id
                left outer join tournament_players tp on tp.tournament_division_id = d.id
                where t.id = #{tournament_id} #{condition}
                group by d.id #{sort}}

   find_by_sql(query)
 end

 def self.tournament_division_players(division)
   query = %Q{  SELECT tp.id as player_id, concat(acp.first_name,' ',acp.last_name) as name
                from tournament_players tp
                join tournament_divisions td on td.id = tp.tournament_division_id
                join account_profiles acp on acp.user_id = tp.user_id
                join account_playing_details apd on apd.user_id = tp.user_id
                where td.id = #{division} }
   find_by_sql(query)
 end

 def self.tournament_categories_levels(tournament_id, sort)
   query = %Q{  select tc.name as category, tc.id as category_id, pl.name as player_level, pl.id as level_id, count(tp.id) as total_players, count(case when tp.tournament_division_id > 0 then 1 end ) as allotted_players
                from tournaments t
                join tournament_players tp on tp.tournament_id = t.id
                left outer join tournament_categories tc on tc.id = tp.tournament_category_id
                left outer join player_levels pl on pl.id = tp.player_level_id
                where t.id = #{tournament_id}
                group by tc.id, pl.id
                order by #{sort} }
   find_by_sql(query)
 end

 def self.create_draw?(tournament_id, level_id, category_id)
   flag = false
   query = %Q{  select count(tp.id) as total_players, count(case when tp.tournament_division_id > 0 then 1 end ) as allotted_players
                from tournaments t
                join tournament_players tp on tp.tournament_id = t.id
                left outer join tournament_categories tc on tc.id = tp.tournament_category_id
                left outer join player_levels pl on pl.id = tp.player_level_id
                where t.id = #{tournament_id} and pl.id = #{level_id} and tc.id = #{category_id}
                group by tc.id, pl.id}
   result = find_by_sql(query)[0]
   total = result.total_players.to_i
   allotted = result.allotted_players.to_i
   if total == allotted
     flag = true
   end
   return flag
 end
end
