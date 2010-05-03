class Tournament < ActiveRecord::Base
 has_many :tournament_palyers
 has_many :tournament_divisions 
end
