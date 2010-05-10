class AlterTournamentsAlterForeignKeyCategoryId < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `tournament_players` DROP FOREIGN KEY `tournament_players_ibfk_5`}
    execute %Q{ ALTER TABLE `tournament_players` CHANGE COLUMN `category_id` `tournament_category_id` INT(11) UNSIGNED NOT NULL,
                DROP INDEX `category_id`,
                ADD INDEX `tournament_category_id` USING BTREE(`tournament_category_id`),
                ADD CONSTRAINT `tournament_players_ibfk_5` FOREIGN KEY `tournament_players_ibfk_5` (`tournament_category_id`) REFERENCES `tournament_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE}
  end

  def self.down
  end
end
