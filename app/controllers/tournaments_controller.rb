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
    @players = Tournament.list_of_tournament_players(params[:id])
  end

  def knockout_points
    @players = Tournament.find(params[:id]).tournament_players
  end

end
