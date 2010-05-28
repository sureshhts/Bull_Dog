# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def player_opponent_score_display(player, opponents, lsg)    
    op_player = (opponents.length > 0)? TournamentPlayer.find(opponents[0]) : nil
    display_text = ""
    points = ""
    if op_player != nil
      op_profile = op_player.user.account_profile
      display_text += "vs #{op_profile.first_name} #{op_profile.last_name}"     
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
    end
    return points, display_text
  end
end
