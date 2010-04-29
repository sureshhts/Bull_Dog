class CreateTournamentPlayers < ActiveRecord::Migration
  def self.up
     execute %Q(
    create table tournament_players(
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	user_id INT(11) UNSIGNED NOT NULL,
	tournament_id INT(11) UNSIGNED NOT NULL,
	division_id INT(11) UNSIGNED default NULL,
	level_id INT(11) UNSIGNED NOT NULL,
	category_id INT(11) UNSIGNED NOT NULL,
	Primary key(id),
	Foreign key(tournament_id) references tournaments(id) on delete cascade on update cascade,
	Foreign key(user_id) references users(id) on delete cascade on update cascade,
	Foreign key(division_id) references tournament_divisions(id) on delete cascade on update cascade,
	Foreign key(level_id) references player_levels(id) on delete cascade on update cascade,
	Foreign key(category_id) references tournament_categories(id) on delete cascade on update cascade
	)Engine = InnoDB;
  )
  end

  def self.down
    drop_table :tournament_players
  end
end
