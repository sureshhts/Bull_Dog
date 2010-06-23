class TournamentCategoryController < ApplicationController
 
layout 'default'
 
  def index
   @category = TournamentCategory.find(:all)
  end

 def categories
 
 end
 
 def create
 
 	if params['commit']  == 'Cancel'
	   redirect_to :action => 'categories'
	   return
   else
   
   end
    
 	@category = TournamentCategory.create(params[:category])
  
	if @category.save
	   flash[:notice] =  'Tournament Category Created Successfully'
	   redirect_to :action => 'index', :controller => 'tournament_category'
	else
	   render :action => 'categories'
	end
 end
 
 def edit_category
  @category = TournamentCategory.find(params[:id])
 
 end
 
 def update
  @category = TournamentCategory.find(params[:id])
  
   if @category.update_attributes(params[:level])
      flash[:notice] = 'Player Level updated successfully.'
      redirect_to :action => 'index'
    else
      redirect_to :action => 'edit_player_lavel', :id => 'params[:id]'
    end
 end
 
 def delete
  	 TournamentCategory.delete(params[:id])
  	 redirect_to :controller => 'tournament_category', :action => 'index'
  end
 

end
