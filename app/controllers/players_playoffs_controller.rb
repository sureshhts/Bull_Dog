class PlayersPlayoffsController < ApplicationController

layout 'player'

  def playoffscores
  
  end
  
  def score
   @categories = TournamentCategory.find(:all)
 
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
