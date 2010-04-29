class PlayerLevelController < ApplicationController

	def add_level
	
	end
	
	def create
		if params['commit']  == 'Cancel'
		   redirect_to :action => ''
		   return
	    else
    	end
    
    
    	@level= PlayerLevel.create(params[:level])
 	
  		if @level.save
		   flash[:notice] =  'New Player Level Created Successfully'
		   redirect_to :action => 'index', :controller => 'player_level'
		else
	  	   render :action => 'new'
	    end
  end

end
