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
    @tp_division = @tp.tournament_division
    @tp_division_schedules = @tp_division.tournament_division_league_schedules
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
    stps = @selected_lsg.tournament_players
    @opponent = nil
    for stp in stps
      if stp.id != @tp.id
        @opponent = stp
      end
    end
    @opponent_profile = @opponent.user.account_profile
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
end
