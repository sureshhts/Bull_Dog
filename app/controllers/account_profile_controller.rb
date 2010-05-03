class AccountProfileController < ApplicationController

layout "player"

  def myprofile
    @profile = AccountProfile.find(params[:id])
  end
  
  def update_profile
  
  	@profile = AccountProfile.find(params[:id])
  	
  	if @profile.update_attributes(params[:profile])
     
      flash[:notice] = 'Your Profile was successfully updated.'
      redirect_to :controller => 'account_profile', :action => 'myprofile', :id => params[:id]
    else
      render :action => "myprofile"
    end
  end
end
