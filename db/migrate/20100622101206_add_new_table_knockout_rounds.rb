class AddNewTableKnockoutRounds < ActiveRecord::Migration
  def self.up
    execute %Q{ CREATE TABLE `knockout_rounds` (
                `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
                `tournament_id` INT(11) UNSIGNED,
                `round_number` INT(11) unsigned,
                `no_of_games` INT(11) unsigned,
                `start_date` INT(11) unsigned,
                `end_date` INT(11) unsigned,
                PRIMARY KEY (`id`),
                INDEX `Index_k1` USING BTREE(`tournament_id`),
                CONSTRAINT `FK_tournament_id_1` FOREIGN KEY `FK_tournament_id_1` (`tournament_id`)
                  REFERENCES `tournaments` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE
              )
              ENGINE = InnoDB
              }

    execute %Q{  ALTER TABLE `knockout_games` DROP COLUMN `start_date`,
                 DROP COLUMN `end_date`,
                 ADD COLUMN `knockout_round_id` INT(11) UNSIGNED AFTER `round`,
                 ADD INDEX `Index_k6` USING BTREE(`knockout_round_id`),
                 ADD CONSTRAINT `FK_knockout_games_5` FOREIGN KEY `FK_knockout_games_5` (`knockout_round_id`)
                    REFERENCES `knockout_rounds` (`id`)
                    ON DELETE CASCADE
                    ON UPDATE CASCADE }
  end

  def self.down
  end
end
