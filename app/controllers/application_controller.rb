# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def isAdmin?
    if User.find(session[:user_id]).account_type == "admin"
      return true
    else
      return false
    end
  end

  def all_tournaments_for_this_month
    today = Time.now
    current_month = today.month
    current_year = today.year
    schedules = Hash.new
    user = User.find(session[:user_id])
    tps = user.tournament_players

    for tp in tps
      games = tp.league_schedule_games
      tournament = tp.tournament
      for game in games
        if game.winner.blank? && game.loser.blank?
          schedule = game.tournament_division_league_schedule
          division = schedule.tournament_division
          level = division.player_level
          category = division.tournament_category
          game_players = game.tournament_players
          index = nil
          if game_players[0].id == tp.id
            index = 0
          else
            index = 1
          end
          game_players.delete_at(index)
          opponent = game_players[0]
          opponent_name = nil
          if opponent.blank?
            opponent_name = "Random"
          else
            opp_profile = opponent.user.account_profile
            opponent_name = [opp_profile.first_name, opp_profile.last_name].join(" ")
          end
          
          start = Time.at(schedule.start_date.to_i)
          if start.month == current_month && start.year == current_year
            detail = {"tournament" => tournament.name, "category" => category.name, "level" => level.name, "place" => division.area_name, "opponent" => opponent_name}
            if schedules[start.day.to_s].blank?
              schedules[start.day.to_s] = Array.new
              schedules[start.day.to_s].push(detail)
            else
              schedules[start.day.to_s].push(detail)
            end
          end
        end
      end
    end
    return [current_month, current_year, schedules]
  end
end
