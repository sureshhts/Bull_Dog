class FacilityController < ApplicationController

layout 'default'

  def index
   @facility = Facility.find(:all)
  end

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
  
  def delete
    Facility.delete(params[:id])
  	redirect_to :controller => 'facility', :action => 'index'
  end
  
  def edit_facility
   	@facility = Facility.find(params[:id])
  end
  
  def update
  
  	@facility = Facility.find(params[:id])
  	
  	if @facility.update_attributes(params[:facility])
      flash[:notice] = "Facility updated successfully"
      redirect_to :action => 'index', :controller => 'facility'
    else
      flash[:notice] = "Try again"
      redirect_to :action => 'edit_facility', :controller => 'facility', :id => params[:id]
    end  
      
  end 

end
