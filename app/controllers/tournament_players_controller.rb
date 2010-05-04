class TournamentPlayersController < ApplicationController

layout 'player'

 def tour_player_registration
  @player_levels = PlayerLevel.find(:all)
  @category = TournamentCategory.find(:all)
  @tournament = Tournament.find(:all)
  puts "******user id*******"
  puts @id = session[:user_id]
 end
 
 def create
   if params['commit']  == 'Cancel'
		   redirect_to :action => ''
		   return
	    else
    	end
    	
     tour_id = params[:tournament][:tournament_id]
     category_id = params[:tournament][:category]
     level_id = params[:tournament][:player_level]
     
     @tournament = Tournament.create(:user_id=> params[:tournament][:user_id], :tournament_id => tour_id, :level_id => level_id, :category_id => category_id)
    
    	@reg= TournamentPlayer.create(:user_id=> params[:tournament][:user_id], :tournament_id => tour_id, :level_id => level_id, :category_id => category_id)
 	
  		if @reg.save
		   flash[:notice] =  'New Player Level Created Successfully'
		   redirect_to :action => 'tour_player_registration', :controller => 'tournament_player'
		else
	  	   render :action => ''
	    end
 
 end
 
 
end
