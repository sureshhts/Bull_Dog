class FacilityController < ApplicationController

  def add_facilities
  
  end
  
  
  def create
    if params['commit']  == 'Cancel'
	   redirect_to :action => ''
	   return
    else
    end
    
    
    @facility= Facility.create(params[:facility])
 	
  	if @facility.save
	   flash[:notice] =  'New Faciltiy Created Successfully'
	   redirect_to :action => 'index', :controller => 'facility'
	else
	   render :action => 'new'
	end
  end

end
