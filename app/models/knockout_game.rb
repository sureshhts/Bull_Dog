class KnockoutGame < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :winner, :class_name => "TournamentPlayer", :foreign_key => 'winner'
  belongs_to :loser, :class_name => "TournamentPlayer", :foreign_key => 'loser'
  has_many :knockout_game_players
  has_many :tournament_players, :through => :knockout_game_players
  belongs_to :knockout_round
  
  #self-join for parent and child relationship
  has_many :knockouts, :class_name => "KnockoutGame", :foreign_key => "parent_game_id"
  belongs_to :parent_knockout, :class_name => "KnockoutGame"

  def self.level_knockout_games(tournament, rounds)
    query = %Q{ select id, round as rnd from knockout_games where tournament_id = #{tournament}}
    result1 = find_by_sql(query)

    round_games = Hash.new
    i = rounds
    until i <= 0
      round_games[i.to_s] = Array.new
      i-=1
    end

    for res in result1
      round_games[res.rnd.to_s].push(res.id)
    end

    final_result = Hash.new
    round_games.each_pair{|key, value|
      final_result[key] = value.reverse
    }

    return final_result
  end
end