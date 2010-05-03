class AccountPlayingDetail < ActiveRecord::Base
  belongs_to :user
  belongs_to :facility
  belongs_to :player_level
  
end
