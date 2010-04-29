class CreateFacilitiesTournamentDivisions < ActiveRecord::Migration
  def self.up
    execute %Q(
    create table facilities_tournament_divisions(
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	tournament_division_id INT(11) UNSIGNED NOT NULL,
	facility_id INT(11) UNSIGNED NOT NULL,
	Primary key(id),
	Foreign key(tournament_division_id) references tournament_divisions(id) on delete cascade on update cascade,
	Foreign key(facility_id) references facilities(id) on delete cascade on update cascade
	)Engine=InnoDB;
  )
  end

  def self.down
    drop_table :facilities_tournament_divisions
  end
end
