class CreatePlayersPlayoffs < ActiveRecord::Migration
  def self.up
    execute %Q(
   create table players_playoffs(
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	tournament_player_id INT(11) UNSIGNED not NULL,
	opponent INT(11) UNSIGNED default NULL,
	divisional_game_id INT(11) UNSIGNED default NULL,
	game_status enum('1','0') not null default '0',
	game_date INT(11) UNSIGNED not NULL,
	points INT(11) UNSIGNED not NULL,
	Primary key(id),
	Foreign key(tournament_player_id) references tournament_players(id) on delete cascade on update cascade,
	Foreign key(opponent) references tournament_players(id) on delete cascade on update cascade,
	Foreign key(divisional_game_id) references divisional_games(id) on delete cascade on update cascade
	)Engine = InnoDB;
  )
  end

  def self.down
    drop_table :players_playoffs
  end
end
