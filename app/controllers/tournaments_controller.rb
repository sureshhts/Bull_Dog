class TournamentsController < ApplicationController

layout 'default'

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
    sort = case params['sort']
      when "name"  then "name"
      when "name_reverse"  then "name DESC"
      when "user_id"  then "user_id"
      when "user_id_reverse"  then "user_id DESC"
      when "category_name"  then "category_name"
      when "category_name_reverse"  then "category_name DESC"
      when "player_level"  then "player_level"
      when "player_level_reverse"  then "player_level DESC"
      when "facility_name"  then "facility_name"
      when "facility_name_reverse"  then "facility_name DESC"
    end
    sort = "name" if sort.blank?
    @players = Tournament.tournament_players_summary(params[:id], sort)
    @players = @players.paginate(:page=>params[:page],:per_page => per_page)
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
    @tournament = Tournament.find(params[:id])
  end

  def knockout_points
    @players = Tournament.list_of_tournament_players(params[:id])
   
  end
  
  def add_points
 
    
     @players = Tournament.list_of_tournament_players(params[:id])
    
     for t in @players
         tp = TournamentPlayer.find(t.player_id)
	     tp.update_attributes(:points => params["point#{t.player_id}"]) 
	 end
     redirect_to :controller => 'tournaments', :action => "index"
   end
  
  

end
