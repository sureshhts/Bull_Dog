class CreatePlayerLevels < ActiveRecord::Migration
  def self.up
     execute %Q(
    create table player_levels(
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	name varchar(50) not null,
	primary key(id)
	)Engine = InnoDB;
	)
  end

  def self.down
    drop_table :player_levels
  end
end
