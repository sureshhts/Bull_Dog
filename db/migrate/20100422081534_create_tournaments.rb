class CreateTournaments < ActiveRecord::Migration
  def self.up
   	 execute %Q(
    create table tournaments(
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	name varchar(50) not null,
	city varchar(50) not null,
	tournament_type enum('L','K') not null default 'L',
	kind_of_tournament enum('O','S') not null default 'O',
	registration_starts INT(11) UNSIGNED  NOT NULL,
	registration_ends INT(11) UNSIGNED  NOT NULL,
	tournament_starts INT(11) UNSIGNED  NOT NULL,
	category_id INT(11) UNSIGNED NOT null,
	primary key(id)
	)Engine = InnoDB;

	)
  end

  def self.down
    drop_table :tournaments
  end
end
