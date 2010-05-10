module TournamentPlayersHelper
  def tournament_next_action(t_id)
    tournament = Tournament.find(t_id)
    if tournament.tournament_type == "L"
      return "league_division"
    elsif tournament.tournament_type == "K"
      return "knockout_points"
    end
  end
end
