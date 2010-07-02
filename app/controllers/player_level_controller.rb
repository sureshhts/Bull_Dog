class PlayerLevelController < ApplicationController

layout 'default'

  def index
    @level = PlayerLevel.find(:all)
  end

  def add_level
	
  end
	
  def create
	if params['commit']  == 'Cancel'
	   redirect_to :action => ''
	   return
    else
	end
    name = params[:level][:name]
    @validate = PlayerLevel.find(:all, :conditions => ["name=?", name])
    redirect_to :action => 'add_level', :controller => 'player_level'
    if @validate
      flash[:notice] =  'Player Level already exists. Try again with new name'
     else 
	@level= PlayerLevel.create(params[:level])

	if @level.save
	   flash[:notice] =  'New Player Level Created Successfully'
	   redirect_to :action => 'index', :controller => 'player_level'
	else
  	   render :action => 'new'
    end
    
    end
  end
  
  
  def edit_player_level
   @level = PlayerLevel.find(params[:id])
  end
  
  def update
 
    name = params[:level][:name]
    @validate = PlayerLevel.find(:all, :conditions => ["name=?", name])
    redirect_to :action => 'edit_player_level', :controller => 'player_level', :id => params[:id]
    if @validate
     flash[:notice] =  'Player Level already exists. Try again with new name'
   else  
   @level = PlayerLevel.find(params[:id])
   
    if @level.update_attributes(params[:level])
      flash[:notice] = 'Player Level updated successfully.'
      redirect_to :action => 'index'
    else
      redirect_to :action => 'edit_player_lavel', :id => 'params[:id]'
    end
  end
  end
  
  def delete
  	 PlayerLevel.delete(params[:id])
  	 redirect_to :controller => 'player_level', :action => 'index'
  end

end
