class CreateTournamentCategories < ActiveRecord::Migration
  def self.up
     execute %Q(
    create table tournament_categories(
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	name varchar(50) not null,
	primary key(id)
	)Engine = InnoDB;
	)
  end

  def self.down
    drop_table :tournament_categories
  end
end
