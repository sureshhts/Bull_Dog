class DivisionalGame < ActiveRecord::Base
 has_one :player_paloff
 belongs_to :tournament_division
end
