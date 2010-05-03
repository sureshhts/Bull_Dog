class TournamentCategoryMappings < ActiveRecord::Migration
  def self.up
    execute %Q(
      create table tournament_category_mappings(
      id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
      category_id INT(11) UNSIGNED not NULL,
      tournament_id INT(11) UNSIGNED default NULL,
      Primary key(id),
      Foreign key(tournament_id) references tournaments(id) on delete cascade on update cascade,
      Foreign key(category_id) references tournament_categories(id) on delete cascade on update cascade
      )Engine = InnoDB;
    )

    execute %Q{ ALTER TABLE `tournaments` DROP COLUMN `category_id` }
  end

  def self.down
  end
end
