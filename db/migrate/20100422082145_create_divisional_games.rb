class CreateDivisionalGames < ActiveRecord::Migration
  def self.up
   execute %Q(
    create table divisional_games(
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	tournament_division_id INT(11) UNSIGNED not NULL,
	week_number INT(11) UNSIGNED not NULL,
	starts INT(11) UNSIGNED not null,
	ends INT(11) UNSIGNED not null,
	player1_set1 INT(11) UNSIGNED default NULL,
	player1_set2 INT(11) UNSIGNED default NULL,
	player1_set3 INT(11) UNSIGNED default NULL,
	player2_set1 INT(11) UNSIGNED default NULL,
	player2_set2 INT(11) UNSIGNED default NULL,
	player2_set3 INT(11) UNSIGNED default NULL,
	Primary key(id),	
	Foreign key(tournament_division_id) references tournament_divisions(id) on delete cascade on update cascade
	)Engine = InnoDB;
  )
  end

  def self.down
    drop_table :divisional_games
  end
end
