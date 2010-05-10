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
   query = %Q{  SELECT tp.id as player_id, acp.user_id as user_id, concat(acp.first_name,' ',acp.last_name) as name
                from tournaments t
                join tournament_players tp on tp.tournament_id = t.id
                join account_profiles acp on acp.user_id = tp.user_id
                where t.id = #{tournament_id} }
    find_by_sql(query)
 end
end
