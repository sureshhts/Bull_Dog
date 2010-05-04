class Tournament < ActiveRecord::Base
 has_many :tournament_players
 has_many :tournament_divisions
 has_many :tournament_category_mappings
 has_many :tournament_categories, :through => :tournament_category_mappings
end
