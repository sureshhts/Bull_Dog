class PlayersPlayoffsController < ApplicationController

layout 'player'

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
  
  def playoff_scores
   
      userid = session[:user_id]
      sets = params[:score][:sets]
    
  if( !params[:p1g3].blank? and !params[:p2g3].blank? )
  
     @winner_points = 8;
     @looser_points = 6;
     
 
  else        
      	if(params[:p1g1].to_i >= 6 and params[:p1g2].to_i >= 6 and params[:p1g1].to_i > params[:p2g1].to_i and params[:p1g2].to_i > params[:p2g2].to_i )
		   puts "Straight win"
		    @winner_points = 10
		    looser_game = params[:p2g1].to_i + params[:p2g2].to_i
		    @looser_points = lookup(looser_game)
		    
	   end
  
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
