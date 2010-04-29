module Bracket
  class PlayoffBracket
    attr_accessor :team_count, :rounds, :players, :teams

    def initialize(team_count)
      @team_count = team_count
      @rounds = 0
      @players = Array.new
      @teams = Array.new
    end

    def tournament_single_elimination_bracket
      team_set = Array.new
      game_set = Array.new
      max_level = 1

      old_team = 0
      next_game = 1
      parent = Array.new(4)
      parent_num = 0
      team_set[1] = 1

      if @team_count < 2
        return
      end

      max_level += 1
      half_count = 3
      this_team = 2
      until this_team > @team_count
        if this_team == half_count
          half_count = (2 * half_count) - 1
          max_level += 1
        end
        old_team = half_count - this_team
        if this_team == 2
          team_set[2] = 1
          game_set[1] = new_game(0, 1, 2, true, true)
        else
          parent_num = team_set[old_team]
          parent = game_set[parent_num]
          if parent[1] == old_team
            game_set[parent_num] = new_game(parent[0], next_game, parent[2], false, parent[4])
          else
            game_set[parent_num] = new_game(parent[0], parent[1], next_game, parent[3], false)
          end
          game_set[next_game] = new_game(parent_num, old_team, this_team, true, true)
        end
        team_set[this_team] = next_game
        team_set[old_team] = next_game
        next_game += 1
        this_team += 1
      end
      this_level = max_level + 1
      level_status = Array.new(this_level)

      x = 0
      until x > max_level
        level_status[x] = 0
        if x > 0
          @rounds = x          
        end
        x += 1
      end
      
      game_count = 0
      game_count = send_game(game_set, level_status, max_level - 1, 1, team_count, game_count)
      bracket_players
    end

    def bracket_players
      group = 1      
      team = nil
      for player in @players
        player_id = player[0].to_s
        if player_id != "-" && (player[1] == "top" || player[1] == "low")
          if player[1] == "top"
            team = {"player1" => player_id, "player2" => nil, "type" => "vs", "round" => "1", "group" => group}
          elsif player[1] == "low"
            team["player2"] = player_id
            @teams.push(team)
          end
        elsif player_id != "-" && player[1] == "non"          
          player.each_index {|x|
            if player[x] == "top"   
              team = {"player1" => player_id, "player2" => nil, "type" => "bye", "round" => x, "group" => group}
              @teams.push(team)
            elsif player[x] == "low"
              @teams[@teams.length-1]["player2"] = player_id
            end
          }          
        elsif player_id == "-"
          if player[player.length-1] == "non"
            group += 1
          end
        end
      end
    end

    def new_game(parent, first, second, first_is_team, second_is_team)
      game = Array.new(4)
      game[0] = parent
      game[1] = first
      game[2] = second
      game[3] = first_is_team
      game[4] = second_is_team
      return game
    end

    def send_game(game_set, level_status, this_level, one_game, total, how_far)
      game_num = one_game
      game = Array.new(4)
      game = game_set[game_num]
      if game[3]
        how_far = send_team(game[1], level_status, game_num, this_level - 1, total, how_far)
      else
        how_far = send_game(game_set, level_status, this_level - 1, game[1], total, how_far)
      end
      how_far = send_team(0, level_status, game_num, this_level, total, how_far)
      if game[4]
        how_far = send_team(game[2], level_status, game_num, this_level - 1, total, how_far)
      else
        how_far = send_game(game_set, level_status, this_level - 1, game[2], total, how_far)
      end
      return how_far
    end

    def increment(game_status)
      game_status += 1
      if game_status == 4
        game_status = 0
      end
      return game_status
    end

    def send_team(team_number, level_status, game_num, this_level, total, how_far)
      entries = Array.new
      outline = Array.new
      entries[0] = "-"
      entries[1] = "top"
      entries[2] = "mid"
      entries[3] = "low"
      entries[4] = "non"

      level_status[this_level] = increment(level_status[this_level])
      if team_number == 0
        outline.push(entries[0])
      else
        how_far += 1
        outline.push(team_number)
      end
      x = 0
      until x >= level_status.length - 2
        if x == 0 && team_number != 0 && level_status[x] == 0
          outline.push(entries[4])
        else
          outline.push(entries[level_status[x]])
        end
        x += 1
      end
      if game_num == 1 && team_number == 0
        outline.push(entries[4])
      end

      @players.push(outline)

      level_status[this_level] = increment(level_status[this_level])
      return how_far
    end
  end
end
