# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def isAdmin?(account)
    if User.find(account).account_type == "admin"
      return true
    else
      return false
    end
  end
  
  def player_opponent_score_display(player, opponents, lsg)    
    op_player = (opponents.length > 0)? TournamentPlayer.find(opponents[0]) : nil
    display_text = ""
    points = ""
    if op_player != nil
      op_profile = op_player.user.account_profile
      display_text += "vs #{op_profile.first_name} #{op_profile.last_name}"
    else
      display_text += "vs Random"
    end
    if !lsg.winner_score.blank? && !lsg.loser_score.blank?
        display_text += "<br>"
        scores_text = []
        game_status = ""
        if player.id.to_s == lsg.winner.id.to_s
          points = lsg.winner_score
          game_status = (lsg.winner_score.to_i > lsg.loser_score.to_i)? "won" : "tie"
          scores_text = ["#{lsg.winner_set_1.to_i}","-","#{lsg.loser_set_1.to_i}"," ","#{lsg.winner_set_2.to_i}","-","#{lsg.loser_set_2.to_i}"," ","#{lsg.winner_set_3.to_i}","-","#{lsg.loser_set_3.to_i}"]
        elsif player.id.to_s == lsg.loser.id.to_s
          points = lsg.loser_score
          game_status = (lsg.winner_score.to_i > lsg.loser_score.to_i)? "lost" : "tie"
          scores_text = ["#{lsg.loser_set_1.to_i}","-","#{lsg.winner_set_1.to_i}"," ","#{lsg.loser_set_2.to_i}","-","#{lsg.winner_set_2.to_i}"," ","#{lsg.loser_set_3.to_i}","-","#{lsg.winner_set_3.to_i}"]
        end
        display_text += scores_text.join
        display_text += "<br>"
        display_text += game_status
    end
    return points, display_text
  end

  def knockout_player_display(player, lsg)
      display_text = ""
      op_profile = player.user.account_profile
      display_text += "#{op_profile.first_name} #{op_profile.last_name}"
      display_text += "<br>"
      scores_text = []              
      scores_text = ["#{lsg.winner_set_1.to_i}","-","#{lsg.loser_set_1.to_i}"," ","#{lsg.winner_set_2.to_i}","-","#{lsg.loser_set_2.to_i}"," ","#{lsg.winner_set_3.to_i}","-","#{lsg.loser_set_3.to_i}"]
      display_text += scores_text.join       
    
    return display_text
  end

  def knockout_game_display(ko_game)
    players = ko_game.tournament_players
    display_text = "Yet to Play"
    if !players.blank? && players.length == 2
      player1 = players[0].user.account_profile
      player2 = players[1].user.account_profile
      display_text += "<br>"
      display_text += "#{player1.first_name} #{player1.last_name} vs #{player2.first_name} #{player2.last_name}"
    end
    return display_text
  end
end
