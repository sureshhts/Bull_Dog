class PlayerLevel < ActiveRecord::Base
  has_one :account_playing_detail
  has_many :tournament_players
  
end
