class KnockoutGame < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :winner, :class_name => "TournamentPlayer", :foreign_key => 'winner'
  belongs_to :loser, :class_name => "TournamentPlayer", :foreign_key => 'loser'
  has_many :knockout_game_players
  has_many :tournament_players, :through => :knockout_game_players
  
  #self-join for parent and child relationship
  has_many :knockouts, :class_name => "KnockoutGame", :foreign_key => "parent_game_id"
  belongs_to :parent_knockout, :class_name => "KnockoutGame"
end