class AccountProfileController < ApplicationController

layout "player"

  def myprofile
    @profile = AccountProfile.find(session[:user_id])
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

  def my_schedule
    @month, @year, @schedules = all_tournaments_for_this_month
  end

  def my_division_standings
    @tournaments = Tournament.find(:all)
    @levels = PlayerLevel.find(:all)
    @categories = TournamentCategory.find(:all)
    if request.xml_http_request?
      @tournament_divisions = TournamentDivision.find_by_sql("select * from tournament_divisions where tournament_id = #{params[:tournament]} and tournament_category_id = #{params[:category]} and player_level_id = #{params[:level]}")
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'my_div_stand',:partial => "my_division_standings"
          end
        }
      end
    end
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
