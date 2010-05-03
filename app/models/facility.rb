class Facility < ActiveRecord::Base
  has_many :facility_tournament_division
  has_many :account_playing_details
  has_many :facility_tournament_divisions
  has_many :divisions, :through => :facility_tournament_divisions
  
  
end
