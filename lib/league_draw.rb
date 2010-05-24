module LeagueDraw
  class RoundRobin
    attr_accessor :week_games, :total_games, :players, :result

    def initialize(players, total_games)
      @week_games = Hash.new
      @players = players
      check_for_even_count
      @total_games = total_games
      @result = Hash.new
    end

    def draw
      i = 0
      player = Array.new
      player.push(@players[0])
      other_players = @players[1..@players.length]

      @total_games.times do
        round = player+other_players.unshift(other_players.pop)
        team_a = round[0..(round.length-1)/2]
        team_b = round[(round.length-1)/2+1..round.length].reverse
        teams = []

        j = 0
        until j >= team_a.length
          group = []
          group.push(team_a[j])
          group.push(team_b[j])
          teams.push(group)
          j+=1
        end

        @week_games[i] = teams
        i+=1
      end

      @result = @week_games
    end

    def check_for_even_count
      if @players.length%2 != 0
        @players.push("rand")
      end
    end 
  end


  class Draw
    attr_accessor :players, :weeks, :matches_per_week_per_player, :max_matches_per_week, :result, :warnings, :games

    def initialize(players, weeks, matches_per_week_per_player, max_matches_per_week, games)
      @players = players
      @weeks = weeks
      @matches_per_week_per_player = matches_per_week_per_player
      @max_matches_per_week = max_matches_per_week
      @result = Hash.new
      @warnings = Array.new
      @games = games
    end

    def game_draw
      week_matches = Array.new(@weeks)
      i = 0
      @weeks.times do
        week_matches[i] = Array.new
        i += 1
      end
      i = 0
      until i >= @players-1
        j = i + 1
        until j >= @players
          match_played = false
          player1 = i.to_s
          player2 = j.to_s
          k = 0
          until k >= @weeks
            if week_matches[k].length/2 == @max_matches_per_week
              k += 1
              next
            end
            matches = matches_played_by_player(week_matches[k], player1)
            if matches == @matches_per_week_per_player
              k += 1
              next
            end
            matches = matches_played_by_player(week_matches[k], player2)
            if matches == @matches_per_week_per_player
              k += 1
              next
            end
            week_matches[k].push(player1)
            week_matches[k].push(player2)
            match_played = true
            break
          end
          if !match_played
            @warnings.push([player1, player2])
          end
          j += 1
        end
        i += 1
      end

      i = 0
      until i >= @weeks
        @result[i] = Array.new
        match = nil
        k = 0
        j = 0
        until j >= week_matches[i].length
          if j%2 == 0
            if match != nil
              @result[i].push(match)
            end
            match = Array.new
          end
          match.push(week_matches[i][k])
          k += 1
          j += 1
        end
        @result[i].push(match)
        i += 1
      end
    end

    def matches_played_by_player(week_matches, player)
      ret = 0
      i = 0
      until i >= week_matches.length
        if week_matches[i].to_s == player
          ret += 1
        end
        i += 1
      end
      return ret
    end   
  end
end
