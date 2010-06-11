class TournamentsController < ApplicationController

layout 'default'
protect_from_forgery :only => [:destroy]
  def index
    @tournament = Tournament.find(:all)
  end

  def new
    @tour_category = TournamentCategory.find(:all)
  end

  def create  
    if params['commit']  == 'Cancel'
	    redirect_to :action => 'new'
	    return
    end

    reg_starts =  Time.parse(params[:tournament][:registration_starts])
    reg_ends = Time.parse(params[:tournament][:registration_ends])
    tourn_starts = Time.parse(params[:tournament][:tournament_starts])       
 	  @tournament = Tournament.create(:name => params[:tournament][:name], :city => params[:tournament][:city], :tournament_type => 	params[:tournament][:tournament_type], :kind_of_tournament => params[:tournament][:kind_of_tournament], :registration_starts => 	reg_starts,	:registration_ends => reg_ends, :tournament_starts => tourn_starts)

    if @tournament.save
      for cat in params[:tournament][:category_id]
  	    tc_map = TournamentCategoryMapping.create(:tournament_id => @tournament.id, :tournament_category_id => cat.to_i)
  	  end
	    flash[:notice] =  'Tournament Created Successfully'
	    redirect_to :action => 'index', :controller => 'tournaments'
    else
	    render :action => 'new'
    end
  end
  
  def edit_tournament   
  	@tournament = Tournament.find(params[:id])
    @cat = TournamentCategory.find(:all)
    @reg = Time.at(@tournament.registration_starts).strftime("%B %d, %Y")
    @reg_ends = Time.at(@tournament.registration_ends).strftime("%B %d, %Y")
    @tour_date = Time.at(@tournament.tournament_starts).strftime("%B %d, %Y")    
  end
  
  def update  	   
    @tournament = Tournament.find(params[:id])
    reg_starts =  Time.parse(params[:tournament][:registration_starts])
    reg_ends = Time.parse(params[:tournament][:registration_ends])
    tourn_starts = Time.parse(params[:tournament][:tournament_starts])
   
    if @tournament.update_attributes(:name => params[:tournament][:name], :city => params[:tournament][:city], :tournament_type => 	params[:tournament][:tournament_type], :kind_of_tournament => params[:tournament][:kind_of_tournament], :registration_starts =>   		reg_starts,	:registration_ends => reg_ends, :tournament_starts => tourn_starts) 	
      tc_mappings = TournamentCategoryMapping.find(:all, :conditions => ["tournament_id=?", @tournament.id])
      for tcm in tc_mappings
        tcm.destroy
      end
     
      for tcm in params[:tournament][:category_id]
        tc_map = TournamentCategoryMapping.create(:tournament_id => @tournament.id, :tournament_category_id => tcm.to_i)
      end
     
      flash[:notice] = 'Tournament was successfully updated.'     
      redirect_to :controller => 'tournaments', :action => 'index'
    else
      render :action => "edit_tournament"
    end
  end
  
  def delete
  	Tournament.delete(params[:id])
  	redirect_to :controller => 'tournaments', :action => 'index'
  end

  def league_division
    per_page = (params[:per_page].blank?)? 10 : params[:per_page]
    
    @tournament = Tournament.find(params[:id])
#    @categories = @tournament.tournament_categories
#    @levels = PlayerLevel.find(:all)
#    conditions = nil
#
#    if params[:view_all].blank?
#      session[:category] = (params[:category].blank?)? ((session[:category].blank?)? @categories[0].id : session[:category]) : params[:category]
#      session[:level] = (params[:level].blank?)? ((session[:level].blank?)? @levels[0].id : session[:level]) : params[:level]
#      conditions = session[:category], session[:level]
#    else
#      session[:category], session[:level] = nil, nil
#    end

    sort = case params['sort']
      when "category"  then "category"
      when "category_reverse"  then "category DESC"
      when "player_level"  then "player_level"
      when "player_level_reverse"  then "player_level DESC"
      when "total_players"  then "total_players"
      when "total_players_reverse"  then "total_players DESC"
      when "allotted_players"  then "allotted_players"
      when "allotted_players_reverse"  then "allotted_players DESC"
    end
    sort = "category" if sort.blank?

    @categories_levels = Tournament.tournament_categories_levels(params[:id], sort)
#    @players = @players.paginate(:page=>params[:page],:per_page => per_page)

    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'ldm',:partial => "league_division_summary"
          end
        }
      end
    end        
  end

  def players_to_divisions
    @tournament = Tournament.find(params[:id])
    @category = TournamentCategory.find(params[:category])
    @level = PlayerLevel.find(params[:level])
    conditions = params[:category], params[:level]
    @players = Tournament.tournament_players_summary(params[:id], "name", conditions)
    @facilities = Facility.find(:all)
    @areas = AreaName.find(:all)

    if request.post?
      division = TournamentDivision.create(:name => params[:d_name], :tournament_id => @tournament.id, :no_of_players => params[:d_players], :tournament_category_id => params[:category], :player_level_id => params[:level], :area_name => params[:d_area])
      #division_facility = FacilitiesTournamentDivision.create(:tournament_division_id => division.id, :facility_id => params[:d_facility])
    end
    @tournament_divisions = Tournament.tournament_divisions(params[:id], conditions)
    @draw = Tournament.create_draw?(@tournament.id, @level.id, @category.id)
    @max_players = TournamentDivision.division_with_max_players(@tournament.id, @level.id, @category.id)
  end

  def tournament_category_level_draw
    @category = TournamentCategory.find(params[:cid])
    @level = PlayerLevel.find(params[:lid])
    @tournament = Tournament.find(params[:id])
    conditions = params[:cid], params[:lid], "players desc"
    @tournament_divisions = Tournament.tournament_divisions(params[:id], conditions)
    
    for division in @tournament_divisions
      d_players = Tournament.tournament_division_players(division.id)
      players_arr = d_players.collect{|dp| dp.player_id}
      league_draw = LeagueDraw::RoundRobin.new(players_arr, params[:games].to_i)
      league_draw.draw
      league_draw_result = league_draw.result
      league_draw_result.each_pair{|key, value|
        tdls = TournamentDivisionLeagueSchedule.create(:week_number => key, :tournament_division_id => division.id)        
        for val in value
          lsg = LeagueScheduleGame.create(:tournament_division_league_schedule_id => tdls.id)
          if val[0] != "rand"
            LeagueGamePlayer.create(:league_schedule_game_id => lsg.id, :tournament_player_id => val[0])
          end
          if val[1] != "rand"
            LeagueGamePlayer.create(:league_schedule_game_id => lsg.id, :tournament_player_id => val[1])
          end
        end
      }
      t_div = TournamentDivision.find(division.id)
      t_div.update_attributes(:draw_created => "1")
    end
  end
  
  def tour_date(week,date)
    @weeks =  week
    for w in @weeks
       puts  startdate = Time.at(date)
       puts  enddate = Time.at(startdate.to_i+60*60*24*6)
	   day = Time.at(enddate.to_i+60*60*24*1)
	   date = day.to_i
	end
   end

  def category_level_draw_schedules
    @category = TournamentCategory.find(params[:cid])
    @level = PlayerLevel.find(params[:lid])
    @tournament = Tournament.find(params[:id])
    conditions = params[:cid], params[:lid], "players desc"
    @tournament_divisions = Tournament.tournament_divisions(params[:id], conditions)
  end

  def update_player_with_division
    player = params[:player]
    div, division = params[:division].split("_")
    @tp = TournamentPlayer.find(player)
    if division.blank?
      @tp.update_attributes(:tournament_division_id => nil)
    else
      @tp.update_attributes(:tournament_division_id => division)
    end
    @draw = Tournament.create_draw?(@tp.tournament_id, @tp.player_level_id, @tp.tournament_category_id)

    @category = TournamentCategory.find(@tp.tournament_category_id)
    @level = PlayerLevel.find(@tp.player_level_id)
    @tournament = Tournament.find(@tp.tournament_id)
    @max_players = TournamentDivision.division_with_max_players(@tournament.id, @level.id, @category.id)
  end

  def knockout_points
    @players = Tournament.list_of_tournament_players(params[:id])
   
  end
  
  def add_points
    @tournament = Tournament.find(params[:id])
    @players = Tournament.list_of_tournament_players(params[:id])

    @tournament.update_attributes(:knockout_cutoff_percentage => 100, :knockout_count => @players.length, :knockout_selected => '1')
    for t in @players
      tp = TournamentPlayer.find(t.player_id)
	    tp.update_attributes(:points => params["point#{t.player_id}"], :knockout => '1')
	  end
    redirect_to :controller => 'players_playoffs', :action => "selected_knockout_players", :id => params[:id]
  end
   
   def ratings
  
     id = params[:id]
     sort = "points desc"
     @rating = Tournament.tournament_players_summary(id, sort)
   
   end
  
    
   def new_division
     @tournament_id = params[:id]
     @facilities = Facility.find(:all)
     if request.xml_http_request?
       respond_to do |format|
         format.html
         format.js {
           render :update do |page|
             page.replace_html 'lp_divisions',:partial => "new_division"
           end
         }
       end
     end
   end

   def add_new_division
     @tournament = Tournament.find(params[:tournament])
     division = TournamentDivision.create(:name => params[:d_name], :tournament_id => @tournament.id, :no_of_players => params[:d_players])
     division_facility = FacilitiesTournamentDivision.create(:tournament_division_id => division.id, :facility_id => params[:d_facility])
     @tournament_divisions = Tournament.tournament_divisions(params[:tournament])
     if request.xml_http_request?
       respond_to do |format|
         format.html
         format.js {
           render :update do |page|
             page.replace_html 'lp_divisions',:partial => "divisions_summary"
           end
         }
       end
     end
   end

   def cancel_new_division
     @tournament_divisions = Tournament.tournament_divisions(params[:id])
     @tournament = Tournament.find(params[:id])
     if request.xml_http_request?
       respond_to do |format|
         format.html
         format.js {
           render :update do |page|
             page.replace_html 'lp_divisions',:partial => "divisions_summary"
           end
         }
       end
     end
   end

   def divide_players
     @players = Tournament.tournament_players_summary(params[:id], "name")
     @tournament_divisions = Tournament.tournament_divisions(params[:id])
     if request.xml_http_request?
       respond_to do |format|
         format.html
         format.js {
           render :update do |page|
             page.replace_html 'ldm',:partial => "divide_players"
           end
         }
       end
     end
   end

end
