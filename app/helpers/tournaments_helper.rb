module TournamentsHelper
  def sort_table_header(text, param, action)
    key = param
    key += "_reverse" if params[:sort] == param
    options = {
        :url => {:action => action, :params => params.merge({:sort => key, :page => nil})}
    }
    html_options = {
      :title => "Sort by this field",
      :href => url_for(:action => action, :params => params.merge({:sort => key, :page => nil}))
    }
    link_to_remote(text, options, html_options)
  end

  def tournament_division_players(division)
    return Tournament.tournament_division_players(division)
  end
end
