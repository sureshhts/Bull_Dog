class TournamentCategory < ActiveRecord::Base
  has_many :tournament_players
  has_many :tournament_category_mappings
  has_many :tournament_divisions
  has_many :tournaments, :through => :tournament_category_mappings
end
