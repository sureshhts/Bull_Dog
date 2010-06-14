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
  
  def home
    @tournaments = Tournament.tournaments_for_registration(session[:user_id])
    @month, @year, @schedules = all_tournaments_for_this_month
  end
  
  def list
   
     date =  params[:year] + "-" + params[:month] + "-" + params[:id]
    
     res = Time.parse(date).to_i
     
    @tournament = Tournament.find(:all, :conditions => ["tournament_starts=?", res])
    
   if @tournament.nil?
     flash[:notice] = "No such tournament"
     redirect_to :action => 'home', controller => 'account_profile'
  end     
  
  end
  
end
