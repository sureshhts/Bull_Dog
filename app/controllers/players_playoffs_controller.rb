require 'tree'
class PlayersPlayoffsController < ApplicationController

layout 'player'
protect_from_forgery :only => [:destroy]
  def playoffscores
  
  end
  
  def score
   @tournaments = Tournament.find(:all) 
  end

  def playoff_tournament
    @tp = TournamentPlayer.find_by_sql("select * from tournament_players where tournament_id='#{params[:tournament]}' and user_id='#{session[:user_id]}'")[0]
    if @tp != nil
      if @tp.tournament_division_id != nil
        @tp_division = @tp.tournament_division
        @tp_division_schedules = @tp_division.tournament_division_league_schedules
      end
    end
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'div1',:partial => "player_score_div1"
          end
        }
      end
    end
  end

  def playoff_tournament_schedule
    tp_id, td_league_schedule_id = params[:schedule].split(":")
    @tp = TournamentPlayer.find(tp_id)
    league_schedule_games = @tp.league_schedule_games
    @selected_lsg = nil
    for lsg in league_schedule_games
      if lsg.tournament_division_league_schedule_id.to_s == td_league_schedule_id.to_s
        @selected_lsg = lsg
        break
      end
    end
    if @selected_lsg != nil
      stps = @selected_lsg.tournament_players
      @opponent = nil
      for stp in stps
        if stp.id != @tp.id
          @opponent = stp
        end
      end
      @opponent_profile = @opponent.user.account_profile
    end
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'div2',:partial => "player_score_div2"
          end
        }
      end
    end
  end

  def tournament_league_standings
    @tournament = Tournament.find(params[:id])
    @players = TournamentPlayer.tournament_players_league_standings(params[:id])
    @selected = 0

    if request.get?
      @selected_percent, @selected = (@tournament.knockout_cutoff_percentage.blank?)? ["",0] : [@tournament.knockout_cutoff_percentage, @tournament.knockout_count.to_i]
    elsif request.xml_http_request?
      @selected = ((params[:percentage].to_f/100.to_f)*@players.length.to_f).ceil
      @tournament.update_attributes(:knockout_cutoff_percentage => params[:percentage], :knockout_count => @selected)
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'league_standings',:partial => "league_players"
          end
        }
      end
    end
  end

  def my_league_standings
    @tournaments = Tournament.find(:all)
    if request.xml_http_request?      
      @tournament = Tournament.find_by_sql("select * from tournaments where id='#{params[:tournament]}'")[0]
      @tp = TournamentPlayer.find_by_sql("select * from tournament_players where tournament_id='#{params[:tournament]}' and user_id='#{session[:user_id]}'")[0]
      if !@tp.blank?
        @players = TournamentPlayer.tournament_players_league_standings(params[:tournament])
      end
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'mls',:partial => "my_league_standings"
          end
        }
      end
    end
  end

  def change_my_availability
    tp = TournamentPlayer.find(params[:id])
    available_tp = TournamentPlayer.available_knockout_non_selected_player(tp.tournament_id, tp.points)
    tp.update_attributes(:knockout => '0')
    available_tp.update_attributes(:knockout => '1')
    @players = TournamentPlayer.tournament_players_league_standings(tp.tournament_id)
    respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'm_l_s',:partial => "league_knockout_selected"
          end
        }
      end
  end

  def selected_knockout_players
    @tournament = Tournament.find(params[:id])
    if @tournament.knockout_selected.blank?
      @tournament.update_attributes(:knockout_selected => '1')
      @players = TournamentPlayer.tournament_players_league_standings(params[:id])
      selected = @tournament.knockout_count.to_i
      i = 1
      for player in @players
        if i <= selected
          TournamentPlayer.find(player.id).update_attributes(:knockout => '1')
        else
          TournamentPlayer.find(player.id).update_attributes(:knockout => '0')
        end
        i += 1
      end
    end
    @players = TournamentPlayer.tournament_players_league_standings(params[:id])
    
    if isAdmin?
      render :layout => "default"
    end
  end

  def division_playoff_scores
    player = TournamentPlayer.find(params[:player])
    opponent = TournamentPlayer.find(params[:opponent])
    league_schedule_game = LeagueScheduleGame.find(params[:lsg])
    td_league_schedule = league_schedule_game.tournament_division_league_schedule
    @tournament_division = td_league_schedule.tournament_division
    @tournament = @tournament_division.tournament
    @category = @tournament_division.tournament_category
    @level = @tournament_division.player_level
    render :action => "playoff_scores"
  end
  
  def playoff_scores
    player = TournamentPlayer.find(params[:player])
    opponent = TournamentPlayer.find(params[:opponent])
    league_schedule_game = LeagueScheduleGame.find(params[:lsg])
    td_league_schedule = league_schedule_game.tournament_division_league_schedule
    @tournament_division = td_league_schedule.tournament_division
    @tournament = @tournament_division.tournament
    @category = @tournament_division.tournament_category
    @level = @tournament_division.player_level
    
    case params[:score][:sets]
      when "won"  then
        opponent_points = lookup(params[:p2g1].to_i + params[:p2g2].to_i)
        league_schedule_game.update_attributes(:winner => player, :loser => opponent, :winner_set_1 => params[:p1g1], :winner_set_2 => params[:p1g2], :loser_set_1 => params[:p2g1], :loser_set_2 => params[:p2g2], :winner_score => 10, :loser_score => opponent_points)
        pl_points = ((player.points.blank?)? 0 : player.points.to_i) + 10
        op_points = ((opponent.points.blank?)? 0 : opponent.points.to_i) + opponent_points
        player.update_attributes(:points => pl_points)
        opponent.update_attributes(:points => op_points)
      when "won3"  then
        league_schedule_game.update_attributes(:winner => player, :loser => opponent, :winner_set_1 => params[:p1g1], :winner_set_2 => params[:p1g2], :winner_set_3 => params[:p1g3], :loser_set_1 => params[:p2g1], :loser_set_2 => params[:p2g2], :loser_set_3 => params[:p2g3], :winner_score => 8, :loser_score => 6)
        pl_points = ((player.points.blank?)? 0 : player.points.to_i) + 8
        op_points = ((opponent.points.blank?)? 0 : opponent.points.to_i) + 6
        player.update_attributes(:points => pl_points)
        opponent.update_attributes(:points => op_points)
      when "lost"  then
        player_points = lookup(params[:p1g1].to_i + params[:p1g2].to_i)
        league_schedule_game.update_attributes(:loser => player, :winner => opponent, :winner_set_1 => params[:p2g1], :winner_set_2 => params[:p2g2], :loser_set_1 => params[:p1g1], :loser_set_2 => params[:p1g2], :winner_score => 10, :loser_score => player_points)
        pl_points = ((player.points.blank?)? 0 : player.points.to_i) + player_points
        op_points = ((opponent.points.blank?)? 0 : opponent.points.to_i) + 10
        player.update_attributes(:points => pl_points)
        opponent.update_attributes(:points => op_points)
      when "lost3"  then
        league_schedule_game.update_attributes(:loser => player, :winner => opponent, :winner_set_1 => params[:p2g1], :winner_set_2 => params[:p2g2], :winner_set_3 => params[:p2g3], :loser_set_1 => params[:p1g1], :loser_set_2 => params[:p1g2], :loser_set_3 => params[:p1g3], :winner_score => 6, :loser_score => 8)
        pl_points = ((player.points.blank?)? 0 : player.points.to_i) + 6
        op_points = ((opponent.points.blank?)? 0 : opponent.points.to_i) + 8
        player.update_attributes(:points => pl_points)
        opponent.update_attributes(:points => op_points)
      when "default" then
        league_schedule_game.update_attributes(:loser => player, :winner => opponent, :winner_set_1 => 1, :winner_set_2 => 1, :winner_set_3 => 1, :loser_set_1 => 0, :loser_set_2 => 0, :loser_set_3 => 0, :winner_score => 7, :loser_score => 0)
        op_points = ((opponent.points.blank?)? 0 : opponent.points.to_i) + 7
        opponent.update_attributes(:points => op_points)
      when "opp_default"  then
        league_schedule_game.update_attributes(:loser => opponent, :winner => player, :winner_set_1 => 1, :winner_set_2 => 1, :winner_set_3 => 1, :loser_set_1 => 0, :loser_set_2 => 0, :loser_set_3 => 0, :winner_score => 7, :loser_score => 0)
        pl_points = ((player.points.blank?)? 0 : player.points.to_i) + 7
        player.update_attributes(:points => pl_points)
      when "tie"  then "allotted_players"
        league_schedule_game.update_attributes(:loser => player, :winner => opponent, :winner_set_1 => 1, :winner_set_2 => 1, :winner_set_3 => 1, :loser_set_1 => 1, :loser_set_2 => 1, :loser_set_3 => 1, :winner_score => 5, :loser_score => 5)
        pl_points = ((player.points.blank?)? 0 : player.points.to_i) + 5
        op_points = ((opponent.points.blank?)? 0 : opponent.points.to_i) + 5
        player.update_attributes(:points => pl_points)
        opponent.update_attributes(:points => op_points)
    end        	   
  end
  
  def lookup(game)  
   if game >= 9
     return 5
   elsif game >=7
     return 4
   elsif game >= 5
     return 3
   elsif game >=3
     return 2
   elsif game >=1
     return 1
   else
            
   end   
  end

  def create_knockout_draw
    @tournament = Tournament.find(params[:id])
    @tournament.update_attributes(:knockout_created => '1')
    all_players = TournamentPlayer.tournament_players_league_standings(params[:id])
    rank = 1
    @ko_players = Hash.new
    for player in all_players
      if player.knockout.to_s == "1"
        @ko_players[rank.to_s] = player.id
        rank += 1
      end
    end

    pob = Bracket::PlayoffBracket.new(@ko_players.size)
    pob.tournament_single_elimination_bracket
    pob.bracket_players

    pure, ko, n = pob.determine_pure_knockout_level
    pob.levels = n-1
    i = 0
    (pob.levels).times do
      level_name = "G:"
      no_of_games_in_this_level = 2**i
      j = 1
      no_of_games_in_this_level.times do
        ko_game = KnockoutGame.create(:tournament_id => @tournament.id, :round => i+1)
        pob.games.push("#{level_name}#{ko_game.id}")
        j+=1
      end
      i += 1
    end

    pob.create_game_tree

    leaves = Array.new
    pob.root.each_leaf{|leaf|
      leaves.push(leaf)
    }

    if pure
      i = 0
      for l in leaves
        team = pob.teams[i]
        l << Tree::TreeNode.new("#{@ko_players[team['player1']]}", "player")
        l << Tree::TreeNode.new("#{@ko_players[team['player2']]}", "player")
        i += 1
      end
    else
      level = i+1
      level_name = "G:"
      i = 0
      j = 1

      for l in leaves
        team = pob.teams[i]
        l << Tree::TreeNode.new("#{@ko_players[team['player1']]}", "player")
        if !team["player2"].blank?
          l << Tree::TreeNode.new("#{@ko_players[team['player2']]}", "player")
        elsif team["player2"].blank?
          ko_game = KnockoutGame.create(:tournament_id => @tournament.id, :round => level)
          sub_node = l << Tree::TreeNode.new("#{level_name}#{ko_game.id}", "game")
          j += 1
          i += 1
          team = pob.teams[i]
          sub_node << Tree::TreeNode.new("#{@ko_players[team['player1']]}", "player")
          sub_node << Tree::TreeNode.new("#{@ko_players[team['player2']]}", "player")
        end
        i += 1
      end
      if isAdmin?
        render :layout => "default"
      end
    end

    pob.root.each{|game|
      if game.content == "game"
        ko_game_id = game.name.split(":")[1]
        ko_game = KnockoutGame.find(ko_game_id)
        if game.parent != nil
          ko_game_parent_id = game.parent.name.split(":")[1]
          ko_game.update_attributes(:parent_game_id => ko_game_parent_id)
        end
      elsif game.content == "player"
        ko_game_player_id = game.name
        ko_game_id = game.parent.name.split(":")[1]
        KnockoutGamePlayer.create(:knockout_game_id => ko_game_id, :tournament_player_id => ko_game_player_id)
      end
    }
    
  end

  def view_knockout_draw
    @tournament = Tournament.find(params[:id])
    all_players = TournamentPlayer.tournament_players_league_standings(params[:id])
    rank = 1
    @ko_players = Hash.new
    for player in all_players
      if player.knockout.to_s == "1"
        @ko_players[rank.to_s] = player.id
        rank += 1
      end
    end

    @pob = Bracket::PlayoffBracket.new(@ko_players.size)
    @pob.tournament_single_elimination_bracket
    @pob.bracket_players

    @level_ko_games = KnockoutGame.level_knockout_games(@tournament.id, @pob.rounds - 1)
    if isAdmin?
      render :layout => "default"
    end
  end
  
end
