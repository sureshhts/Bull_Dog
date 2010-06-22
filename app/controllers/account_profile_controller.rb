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
    @tournaments = Tournament.find_by_sql("select * from tournaments where tournament_type = 'L'")
    @levels = PlayerLevel.find(:all)
    @categories = TournamentCategory.find(:all)
    if request.xml_http_request?
      @tournament_divisions = Array.new
      tds = TournamentDivision.find_by_sql("select * from tournament_divisions where tournament_id = #{params[:tournament]} and tournament_category_id = #{params[:category]} and player_level_id = #{params[:level]}")
      tp = TournamentPlayer.find_by_sql("select * from tournament_players where user_id = #{session[:user_id]} and tournament_id = #{params[:tournament]}")[0]
      for td in tds
        td_players = Tournament.tournament_division_players(td.id)
        td_pids = td_players.collect{|rec| rec.player_id.to_s}
        if td_pids.include?(tp.id.to_s)
          @tournament_divisions.push(td)
        end
      end

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

  def search_player
    if request.xml_http_request?
      @players = User.search_players(params[:first], params[:last])
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'player_search',:partial => "searched_players"
          end
        }
      end
    end
  end

  def player_history
    user = User.find(params[:user_id])
    @profile = user.account_profile
    @history = TournamentPlayer.player_history(user.id)
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'player_history',:partial => "player_history"
          end
        }
      end
    end
  end

  def level_standings
    @tournaments = Tournament.find_by_sql("select * from tournaments where tournament_type = 'L'")
    @levels = PlayerLevel.find(:all)
    
    if request.xml_http_request?      
      @players = TournamentPlayer.tournament_players_level_standings(params[:tournament], params[:level])
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'level_stand',:partial => "level_standings"
          end
        }
      end
    end
  end

  def division_standings
    @tournaments = Tournament.find_by_sql("select * from tournaments where tournament_type = 'L'")
    @levels = PlayerLevel.find(:all)
    @categories = TournamentCategory.find(:all)
    if request.xml_http_request?
      @tournament_divisions = TournamentDivision.find_by_sql("select * from tournament_divisions where tournament_id = #{params[:tournament]} and tournament_category_id = #{params[:category]} and player_level_id = #{params[:level]}")
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'div_stand',:partial => "division_standings"
          end
        }
      end
    end
  end

  def my_playoff_standings
    @tournaments = Tournament.find(:all)
    if request.xml_http_request?
      @tournament = Tournament.find_by_sql("select * from tournaments where id=#{params[:tournament]}")[0]
      @players = TournamentPlayer.tournament_players_league_standings(params[:tournament])
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'my_play_off',:partial => "my_playoff_standings"
          end
        }
      end
    end
  end

  def change_my_availability
    tp = TournamentPlayer.find(params[:id])
    available_tp = TournamentPlayer.available_knockout_non_selected_player(tp.tournament_id, tp.points)
    tp.update_attributes(:knockout => '0')
    available_tp.update_attributes(:knockout => '1')
    @players = TournamentPlayer.tournament_players_league_standings(tp.tournament_id)
    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
            page.replace_html 'my_play_off',:partial => "my_playoff_standings"
        end
      }
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
  
  def champion_pic
    user_id = session[:user_id]
    @tour_player = TournamentPlayer.find(:all, :conditions => ["user_id=?", user_id])
    @tour_player.each do |p|
     @tournament = Tournament.find(:all , :conditions => ["id=?", p.tournament_id])
    end
  end
  
  def add_pic
    @tour_pic = TournamentPhoto.create(params[:tournament])

  if @tour_pic .save
   
    flash[:notice] = 'Photos uploaded successfully.'
       redirect_to :action => 'show_pic', :controller => 'account_profile'
  else
    render :action => "champion_pic"
  end
  
  end


  def show_pic
    user_id = session[:user_id]
    @tour_player = TournamentPlayer.find(:all, :conditions => ["user_id=?", user_id])
    @tour_player.each do |p|
     @tournament = Tournament.find(:all, :conditions => ["id=?", p.tournament_id])
    end 
    
   
  end
  
  def pictures
  
   id=  params[:tournament_id]
    @tournament = Tournament.find(:first, :conditions => ["id=?",id])
   @pic = TournamentPhoto.find(:all, :conditions => ["tournament_id=?",id])
   
   if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'div1',:partial => "pics"
          end
        }
      end
    end
  
  end
  
  def change_password
   id = session[:user_id]
  end
  
  
end
