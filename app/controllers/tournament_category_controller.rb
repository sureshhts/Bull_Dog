class TournamentCategoryController < ApplicationController
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
	   redirect_to :action => 'categories', :controller => 'tournament_category'
	else
	   render :action => 'categories'
	end
 end
 
end
