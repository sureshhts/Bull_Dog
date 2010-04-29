class CreateTournamentDivisions < ActiveRecord::Migration
  def self.up
    execute %Q(
    create table tournament_divisions(
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	name varchar(50) not null,
	tournament_id INT(11) UNSIGNED NOT NULL,
	no_of_players int(11) UNSIGNED default null,
	Primary key(id),
	Foreign key(tournament_id) references tournaments(id) on delete cascade on update cascade
	)Engine = InnoDB;
  )
  end

  def self.down
    drop_table :tournament_divisions
  end
end
