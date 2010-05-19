module LeagueDraw
  class RoundRobin
    attr_accessor :week_games, :highest_division_players, :players, :actual_players

    def initialize(players, highest_division_players)
      @week_games = Hash.new
      @players = @actual_players = players
      @highest_division_players = highest_division_players
    end

    def draw
      if @highest_division_players-@players.length > 0
        (@highest_division_players-@players.length).times do
          @players.push("rand")
        end
      end

      check_for_even_count

      weeks = @players.length - 1
      i = 0
      player = Array.new
      player.push(@players[0])
      other_players = @players[1..@players.length]

      begin
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
      end while i < weeks

      allocate_random_players if @highest_division_players-@players.length > 0
    end

    def check_for_even_count
      if @players.length%2 != 0
        @players.push("bye")
      end
    end

    def allocate_random_players
      no_of_games = @week_games.size
      team_a = @actual_players[1..(@actual_players.length-1)/2]
      insert_team_b = @actual_players[(@actual_players.length-1)/2+1..@actual_players.length]

      actual_count = @actual_players.length - 1
      freq_players = Hash.new

      for ap in @actual_players
        freq_players[ap] = actual_count
      end

      #allocate first to player 1
      i = 0
      @week_games.each_pair{|key, value|
        if value[0][1] == "rand"
          @week_games[key][0][1] = team_a[i]
          freq_players[@actual_players[0]] += 1
          freq_players[team_a[i]] += 1
          i += 1
        end
      }

      week_values = @week_games.values

      for t_a in team_a
          i = 0
          for week in week_values
            j = 0
            for game in week
              if game.include?("rand") && game.include?(t_a) && freq_players[t_a] < no_of_games
                rand_pos = game.index("rand")
                t_b = insert_team_b.push(insert_team_b.shift)[0]
                @week_games[@week_games.keys[i]][j][rand_pos] = t_b
                freq_players[t_a] += 1
                freq_players[t_b] += 1
              end
              j += 1
            end
            i += 1
          end
      end

      i = 0
      for week in week_values
        j = 0
        for game in week
          if game[0] == "rand" && game[1] == "rand"
            @week_games[@week_games.keys[i]][j][0] = "bye"
            @week_games[@week_games.keys[i]][j][1] = "bye"
            for tb in insert_team_b
              if freq_players[tb] < no_of_games
                @week_games[@week_games.keys[i]][j][0] = tb
                freq_players[tb] += 1
              end
            end
            for tb in insert_team_b
              if freq_players[tb] < no_of_games
                @week_games[@week_games.keys[i]][j][1] = tb
                freq_players[tb] += 1
              end
            end
          end
          j += 1
        end
        i += 1
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
