class CreateAccountPlayingDetails < ActiveRecord::Migration
  def self.up
   execute %Q(
    create table account_playing_details(
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	user_id INT(11) UNSIGNED NOT NULL,
	facility_id INT(11) UNSIGNED NOT NULL,
	player_level_id INT(11) UNSIGNED NOT NULL,
	verified enum('Yes','No') not null default 'No',
	Primary key(id),
	Foreign key(user_id) references users(id) on delete cascade on update cascade,
	Foreign key(facility_id) references facilities(id) on delete cascade on update cascade,
	Foreign key(player_level_id) references player_levels(id) on delete cascade on update cascade
	)Engine = InnoDB;
  )
  end

  def self.down
    drop_table :account_playing_details
  end
end
