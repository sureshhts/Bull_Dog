class CreateDivisionalGames < ActiveRecord::Migration
  def self.up
   execute %Q(
    create table divisional_games(
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	division_id INT(11) UNSIGNED not NULL,
	week_number INT(11) UNSIGNED not NULL,
	starts INT(11) UNSIGNED not null,
	ends INT(11) UNSIGNED not null,
	player1 INT(11) UNSIGNED not null,
	player2 INT(11) UNSIGNED not null,
	player1_set1 INT(11) UNSIGNED default NULL,
	player1_set2 INT(11) UNSIGNED default NULL,
	player1_set3 INT(11) UNSIGNED default NULL,
	player2_set1 INT(11) UNSIGNED default NULL,
	player2_set2 INT(11) UNSIGNED default NULL,
	player2_set3 INT(11) UNSIGNED default NULL,
	Primary key(id),
	Foreign key(player1) references tournament_players(id) on delete cascade on update cascade,
	Foreign key(player2) references tournament_players(id) on delete cascade on update cascade,
	Foreign key(division_id) references tournament_divisions(id) on delete cascade on update cascade
	)Engine = InnoDB;
  )
  end

  def self.down
    drop_table :divisional_games
  end
end
