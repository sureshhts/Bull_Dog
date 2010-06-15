class TournamentPlayersController < ApplicationController

layout 'player'

 def tour_player_registration
    @id = session[:user_id]
    id = params[:id]
    @tournament = Tournament.find(id)
   # @level_id = User.find(session[:user_id]).account_playing_detail.player_level_id
    @player_levels = PlayerLevel.find(:all)
    @category = @tournament.tournament_categories
    @area = AreaName.find(:all)
  end
 
 def create
 
   if params['commit']  == 'Cancel'
	  redirect_to :action => ''
	  return
   else
   end
    	
     tour_id = params[:tournament][:tournament_id]
     puts  category_id = params[:tournament][:category]
    puts category_id.length
     level_id = params[:tournament][:player_level]
     
    
     for cat in params[:tournament][:category]
  	    @reg= TournamentPlayer.create(:user_id=> params[:tournament][:user_id], :tournament_id => tour_id, :player_level_id => level_id,  			:tournament_category_id => cat)	
  	 end
    
 	
  	if @reg
	   flash[:notice] =  'New Player Level Created Successfully'
	   redirect_to :action => 'index', :controller => 'registration'
	else
	   render :action => 'tour_player_registration', :controller => 'tournament_players'
	end
 
 end

 def index
   @summary = Tournament.tournament_summary
   render :layout => "default"
 end
 
end
