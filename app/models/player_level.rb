class PlayerLevel < ActiveRecord::Base
  has_one :account_playing_detail
  has_many :tournament_players
  has_many :tournament_divisions
end
