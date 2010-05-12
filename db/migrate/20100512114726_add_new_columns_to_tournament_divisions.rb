class AddNewColumnsToTournamentDivisions < ActiveRecord::Migration
  def self.up
    execute %Q{  ALTER TABLE `tournament_divisions` ADD COLUMN `tournament_category_id` INT(11) UNSIGNED AFTER `no_of_players`,
                 ADD INDEX `Index_tournament_category_id` USING BTREE(`tournament_category_id`),
                 ADD CONSTRAINT `FK_tournament_divisions_2` FOREIGN KEY `FK_tournament_divisions_2` (`tournament_category_id`)
                    REFERENCES `tournament_categories` (`id`)
                    ON DELETE CASCADE
                    ON UPDATE CASCADE }

    execute %Q{  ALTER TABLE `tournament_divisions` ADD COLUMN `player_level_id` INT(11) UNSIGNED AFTER `tournament_category_id`,
                 ADD INDEX `Index_player_level_id` USING BTREE(`player_level_id`),
                 ADD CONSTRAINT `FK_tournament_divisions_3` FOREIGN KEY `FK_tournament_divisions_3` (`player_level_id`)
                    REFERENCES `player_levels` (`id`)
                    ON DELETE CASCADE
                    ON UPDATE CASCADE}

    execute %Q{  ALTER TABLE `tournament_divisions` ADD COLUMN `area_name` VARCHAR(50) AFTER `player_level_id` }
  end

  def self.down
  end
end
