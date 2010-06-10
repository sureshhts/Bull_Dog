require 'tree'
module Bracket
  class PlayoffBracket
    attr_accessor :team_count, :rounds, :players, :teams, :games, :levels, :root

    def initialize(team_count)
      @team_count = team_count
      @rounds = 0
      @players = Array.new
      @teams = Array.new
      @games = Array.new
    end

    def knockout_brackets
      tournament_single_elimination_bracket
      bracket_players
      create_game_tree
      display
      return nil
    end

    def display
      @root.each{|node|
        puts node
      }
      return nil
    end

    def create_game_tree      
      @games = @games.reverse
      @root = Tree::TreeNode.new("#{@games.pop}", "game")

      (@levels-1).times do
        add_childs
      end

#      complete_the_knockout_tree
      return nil
    end

    def determine_pure_knockout_level
      count = @team_count
      base = 2
      n = 1
      pure = false
      prev = base**n
      n+=1
      cur = nil
      while true
        cur = base**n
        if count == prev
          pure = true
          break
        elsif count > prev && count < cur
          break
        end
        prev = cur
        n += 1
      end

      return pure, prev, n
    end

#    def complete_the_knockout_tree
#      pure, ko, n = determine_pure_knockout_level
#
#      leaves = Array.new
#      @root.each_leaf{|leaf|
#        leaves.push(leaf)
#      }
#
#      if pure
#        i = 0
#        for l in leaves
#          team = @teams[i]
#          l << Tree::TreeNode.new("#{team['player1']}", "Player1")
#          l << Tree::TreeNode.new("#{team['player2']}", "Player2")
#          i += 1
#        end
#      else
#        level_name = "L#{@rounds - 2}"
#        i = 0
#        j = 1
#
#        for l in leaves
#          team = @teams[i]
#          l << Tree::TreeNode.new("#{team['player1']}", "Player1")
#          if !team["player2"].blank?
#            l << Tree::TreeNode.new("#{team['player2']}", "Player2")
#          elsif team["player2"].blank?
#            sub_node = l << Tree::TreeNode.new("#{level_name}#{j}", "")
#            j += 1
#            i += 1
#            team = @teams[i]
#            sub_node << Tree::TreeNode.new("#{team['player1']}", "Player1")
#            sub_node << Tree::TreeNode.new("#{team['player2']}", "Player2")
#          end
#          i += 1
#        end
#      end
#      return nil
#    end

    def add_childs
      leaves = Array.new
      @root.each_leaf{|leaf|
        leaves.push(leaf)
      }

      for l in leaves
        l << Tree::TreeNode.new("#{@games.pop}", "game")
        l << Tree::TreeNode.new("#{@games.pop}", "game")
      end
      return nil
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
      return nil
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
      return nil
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
