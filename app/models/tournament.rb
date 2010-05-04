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
end
